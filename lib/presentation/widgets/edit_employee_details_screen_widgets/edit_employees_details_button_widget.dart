import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/utilities/dependency_injection.dart';
import '../../../domain/entities/employee.dart';
import '../../../domain/use cases/edit_employee_details_use_case.dart';
import '../../screens/edit_employee_details_screen.dart';
import '../../screens/zoom_drawer.dart';

class EditEmployeeDetailsButton extends StatelessWidget {
  const EditEmployeeDetailsButton({
    Key? key,
    required this.appProvider,
    required this.employee,
    required this.widget,
    required this.workingTo,
    required this.workingFrom,
    required this.mq,
    required this.listKey,
    required this.allowedDelayHours,
    required this.allowedDelayMinutes,
    required this.isConnectionWorking,
  }) : super(key: key);

  final AppProvider appProvider;
  final Employee employee;
  final EditEmployeeDetailsScreen widget;
  final TimeOfDay? workingTo;
  final TimeOfDay? workingFrom;
  final Size mq;
  final String allowedDelayHours, allowedDelayMinutes;
  final bool isConnectionWorking;
  final GlobalKey<SliverAnimatedListState> listKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 3,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: !isConnectionWorking
            ? null
            : () async {
                final navigator = Navigator.of(context);
                final theme = Theme.of(context).colorScheme;
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                if (appProvider.offDaysGetter().isEmpty) {
                  bool noVacationAccepted = false;
                  await Alert(
                    context: context,
                    title: 'تحذير',
                    desc: 'هل انت متأكد من عدم اعطاء الموظف اي اجازات',
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
                          noVacationAccepted = true;
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
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ).show();
                  if (!noVacationAccepted) {
                    return;
                  }
                }
                if (appProvider.checkIFAllowedDelayTimeIsZero()) {
                  bool noAllowedDelayAccepted = false;
                  await Alert(
                    context: context,
                    title: 'تحذير',
                    desc:
                        'هل انت متأكد من عدم اعطاء الموظف اي وقت مسموح للتأخير',
                    type: AlertType.warning,
                    style: AlertStyle(
                      backgroundColor: theme.background,
                      titleStyle: TextStyle(
                        color: theme.onBackground,
                      ),
                      descStyle: TextStyle(
                        color: theme.onBackground,
                      ),
                    ),
                    closeIcon: Icon(
                      Icons.close,
                      color: theme.onBackground,
                    ),
                    buttons: [
                      DialogButton(
                        color: theme.primary,
                        child: Text(
                          'نعم',
                          style: TextStyle(
                            color: theme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          noAllowedDelayAccepted = true;
                          Navigator.pop(context);
                        },
                      ),
                      DialogButton(
                        color: theme.primary,
                        child: Text(
                          'لا',
                          style: TextStyle(
                            color: theme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ).show();
                  if (!noAllowedDelayAccepted) {
                    return;
                  }
                }

                appProvider.changeLoading(true);
                appProvider.workingFromString =
                    appProvider.correctWorkingTimesToIso(
                        '${appProvider.workingFrom!.hour}:${appProvider.workingFrom!.minute}');
                appProvider.workingToString = appProvider.correctWorkingTimesToIso(
                    '${appProvider.workingTo!.hour}:${appProvider.workingTo!.minute}');

                await getIt
                    .get<EditEmployeeDetailsUseCase>()
                    .editEmployeeDetails(
                      employee,
                      widget.textEditingController.value.text,
                      appProvider.workingFromString!,
                      appProvider.workingToString!,
                      appProvider.offDaysGetter(),
                      appProvider.vacationDays,
                      appProvider.getAllowedDelay(),
                    );

                appProvider.changeLoading(false);

                Future.delayed(
                  const Duration(
                    milliseconds: 200,
                  ),
                ).then((value) => widget.appProvider.clear());

                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: const Text('تم الحفظ بنجاح'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
                navigator.popUntil(
                  ModalRoute.withName(ZoomDrawerScreen.id),
                );
              },
        child: FittedBox(
          child: appProvider.loading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  'حفظ',
                  style: TextStyle(fontSize: mq.width * 0.06),
                ),
        ),
      ),
    );
  }
}
