import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../core/providers/app_provider.dart';
import '../../core/providers/network_provider.dart';
import '../../domain/entities/employee.dart';
import '../widgets/adding_new_employee_screen_widgets/exports.dart';
import '../widgets/edit_employee_details_screen_widgets/exports.dart';
import '../widgets/exports.dart';

class EditEmployeeDetailsScreen extends StatefulWidget {
  const EditEmployeeDetailsScreen({
    Key? key,
    required this.employee,
    required this.textEditingController,
    required this.appProvider,
  }) : super(key: key);
  final Employee employee;
  final TextEditingController textEditingController;
  final AppProvider appProvider;

  @override
  State<EditEmployeeDetailsScreen> createState() =>
      _EditEmployeeDetailsScreenState();
}

class _EditEmployeeDetailsScreenState extends State<EditEmployeeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _animatedListKey = GlobalKey<SliverAnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;
    final employee = widget.employee;
    final appProvider = Provider.of<AppProvider>(context);
    final workingFrom = appProvider.workingFrom;
    final workingTo = appProvider.workingTo;
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final mq = mediaQuery.size;
    return WillPopScope(
      onWillPop: () async {
        bool popWithoutSaving = false;

        await Alert(
          context: context,
          title: 'تحذير',
          desc: 'هل انت متأكد من عدم حفظ التغييرات',
          type: AlertType.warning,
          style: AlertStyle(
            backgroundColor: Theme.of(context).colorScheme.background,
            titleStyle: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            descStyle: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          closeIcon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          buttons: [
            DialogButton(
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'نعم',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                popWithoutSaving = true;
                appProvider.clear();
                Navigator.pop(context);
              },
            ),
            DialogButton(
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'لا',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                popWithoutSaving = false;
                Navigator.pop(context);
              },
            ),
          ],
        ).show();
        return popWithoutSaving;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: isPortrait ? mq.height * 0.07 : mq.width * 0.07,
                  child: EditEmployeeDetailsButton(
                    listKey: _animatedListKey,
                    isConnectionWorking: isConnectionWorking,
                    appProvider: appProvider,
                    employee: employee,
                    widget: widget,
                    workingTo: workingTo,
                    workingFrom: workingFrom,
                    allowedDelayHours: appProvider.allowedDelayHours,
                    allowedDelayMinutes: appProvider.allowedDelayMinutes,
                    mq: mq,
                  ),
                ),
                NoConnectionBottomBar(
                  isConnectionWorking
                      ? 0
                      : isPortrait
                          ? mq.height * 0.07
                          : mq.width * 0.07,
                ),
              ],
            ),
            appBar: AppBar(
              title: const Text('تعديل بيانات الموظف'),
            ),
            body: Builder(
              builder: (context) {
                if (isPortrait) {
                  return CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 20, left: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              AddNewEmployeeTextField(
                                formKey: _formKey,
                                textEditingController:
                                    widget.textEditingController,
                              ),
                              SizedBox(height: mq.width * 0.04),
                              ElevatedButtonTheme(
                                data: ElevatedButtonThemeData(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontSize: mq.width * 0.05,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    backgroundColor: appProvider.errorState
                                        ? Colors.red
                                        : Theme.of(context)
                                            .colorScheme
                                            .background,
                                    foregroundColor: appProvider.errorState
                                        ? Colors.white
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                child: WorkingTimeSelectionWidget(
                                  isPortrait: isPortrait,
                                  fontSize: mq.width * 0.07,
                                  mq: mq,
                                  workingFrom: workingFrom,
                                  weekDaysProvider: appProvider,
                                  workingTo: workingTo,
                                ),
                              ),
                              SizedBox(height: mq.width * 0.04),
                              OffDaysSelectorWidget(
                                isPortrait: isPortrait,
                                weekDaysProvider: appProvider,
                                mq: mq,
                              ),
                              SizedBox(height: mq.width * 0.04),
                              SizedBox(
                                height: mq.height * 0.25,
                                child: AllowedDelayWidget(
                                  mq: mq,
                                  isPortrait: isPortrait,
                                ),
                              ),
                              SizedBox(height: mq.width * 0.04),
                              Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'الاجازات الاضافية',
                                        style: TextStyle(
                                          fontSize: mq.width * 0.07,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(320),
                                    splashColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        child: const Icon(Icons.add),
                                      ),
                                    ),
                                    onTap: () async {
                                      final scaffoldMessenger =
                                          ScaffoldMessenger.of(context);
                                      final theme =
                                          Theme.of(context).colorScheme;
                                      final vacationDay = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now()
                                            .add(const Duration(days: 1)),
                                        firstDate: DateTime.now()
                                            .add(const Duration(days: 1)),
                                        lastDate: DateTime(
                                          DateTime.now().year + 2,
                                        ),
                                      );
                                      if (appProvider.vacationDays
                                          .contains(vacationDay)) {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'تم اضافة هذا اليوم بالفعل',
                                            ),
                                            backgroundColor: theme.onBackground,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        return;
                                      }
                                      if (vacationDay != null) {
                                        appProvider.addToVacationDays(
                                          vacationDay,
                                          _animatedListKey,
                                        );
                                        await Future.delayed(
                                          const Duration(milliseconds: 700),
                                        );
                                        _scrollController.animateTo(
                                          _scrollController
                                                  .position.maxScrollExtent +
                                              100,
                                          duration:
                                              const Duration(milliseconds: 800),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (appProvider.vacationDays.isEmpty)
                                Text(
                                  'لا يوجد اي اجازات اضافية للموظف',
                                  style: TextStyle(
                                    fontSize: mq.width * 0.05,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            bottom: 20, right: 20, left: 20),
                        sliver: SliverAnimatedList(
                          initialItemCount: appProvider.vacationDays.length,
                          key: _animatedListKey,
                          itemBuilder: (context, index, animation) {
                            final vacationDay = appProvider.vacationDays[index];
                            final String formattedDayInArabic =
                                DateFormat.yMMMMEEEEd('ar').format(vacationDay);
                            return SizeTransition(
                              sizeFactor: animation,
                              child: VacationDaysEditingWidget(
                                vacationDay: vacationDay,
                                fontSize: mq.width * 0.045,
                                onTapFunction: () {
                                  appProvider.deleteDayFromVacationDays(
                                    vacationDay,
                                    _animatedListKey,
                                    mq.width * 0.045,
                                    formattedDayInArabic,
                                  );
                                },
                                formattedDayInArabic: formattedDayInArabic,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 20, left: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              AddNewEmployeeTextField(
                                formKey: _formKey,
                                textEditingController:
                                    widget.textEditingController,
                              ),
                              SizedBox(
                                height: mq.height * 0.05,
                              ),
                              SizedBox(
                                height: mq.height * 0.55,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButtonTheme(
                                        data: ElevatedButtonThemeData(
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(
                                              fontSize: mq.width * 0.05,
                                              fontWeight: FontWeight.w800,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            backgroundColor:
                                                appProvider.errorState
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                            foregroundColor:
                                                appProvider.errorState
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                          ),
                                        ),
                                        child: WorkingTimeSelectionWidget(
                                          isPortrait: isPortrait,
                                          fontSize: mq.width * 0.07,
                                          mq: mq,
                                          workingFrom: workingFrom,
                                          weekDaysProvider: appProvider,
                                          workingTo: workingTo,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: mq.width * 0.02,
                                    ),
                                    Expanded(
                                      child: AllowedDelayWidget(
                                        mq: mq,
                                        isPortrait: isPortrait,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: mq.height * 0.05,
                              ),
                              OffDaysSelectorWidget(
                                isPortrait: isPortrait,
                                weekDaysProvider: appProvider,
                                mq: mq,
                              ),
                              SizedBox(height: mq.height * 0.03),
                              Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'الاجازات الاضافية',
                                        style: TextStyle(
                                          fontSize: mq.height * 0.08,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(320),
                                    splashColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        child: const Icon(Icons.add),
                                      ),
                                    ),
                                    onTap: () async {
                                      final scaffoldMessenger =
                                          ScaffoldMessenger.of(context);
                                      final theme =
                                          Theme.of(context).colorScheme;
                                      final vacationDay = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now()
                                            .add(const Duration(days: 1)),
                                        firstDate: DateTime.now()
                                            .add(const Duration(days: 1)),
                                        lastDate: DateTime(
                                          DateTime.now().year + 2,
                                        ),
                                      );
                                      if (appProvider.vacationDays
                                          .contains(vacationDay)) {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'تم اضافة هذا اليوم بالفعل',
                                            ),
                                            backgroundColor: theme.onBackground,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        return;
                                      }
                                      if (vacationDay != null) {
                                        appProvider.addToVacationDays(
                                          vacationDay,
                                          _animatedListKey,
                                        );
                                        await Future.delayed(
                                          const Duration(milliseconds: 700),
                                        );
                                        _scrollController.animateTo(
                                          _scrollController
                                                  .position.maxScrollExtent +
                                              100,
                                          duration:
                                              const Duration(milliseconds: 800),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (appProvider.vacationDays.isEmpty)
                                Text(
                                  'لا يوجد اي اجازات اضافية للموظف',
                                  style: TextStyle(
                                    fontSize: mq.height * 0.05,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            bottom: 20, right: 20, left: 20),
                        sliver: SliverAnimatedList(
                          initialItemCount: appProvider.vacationDays.length,
                          key: _animatedListKey,
                          itemBuilder: (context, index, animation) {
                            final vacationDay = appProvider.vacationDays[index];
                            final String formattedDayInArabic =
                                DateFormat.yMMMMEEEEd('ar').format(vacationDay);
                            return SizeTransition(
                              sizeFactor: animation,
                              child: VacationDaysEditingWidget(
                                vacationDay: vacationDay,
                                fontSize: mq.height * 0.06,
                                onTapFunction: () {
                                  appProvider.deleteDayFromVacationDays(
                                    vacationDay,
                                    _animatedListKey,
                                    mq.height * 0.06,
                                    formattedDayInArabic,
                                  );
                                },
                                formattedDayInArabic: formattedDayInArabic,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
