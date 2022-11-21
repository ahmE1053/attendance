import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../../core/providers/network_provider.dart';
import '../widgets/adding_new_employee_screen_widgets/exports.dart';
import '../widgets/exports.dart';

class AddNewEmployee extends StatefulWidget {
  static const id = 'addNewEmployee';

  const AddNewEmployee({Key? key}) : super(key: key);

  @override
  State<AddNewEmployee> createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weekDaysProvider = Provider.of<AppProvider>(context);
    final workingFrom = weekDaysProvider.workingFrom;
    final workingTo = weekDaysProvider.workingTo;
    final mediaQuery = MediaQuery.of(context);
    final mq = mediaQuery.size;
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          weekDaysProvider.clear();
          return true;
        },
        child: Scaffold(
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: isPortrait ? mq.height * 0.07 : mq.width * 0.07,
                width: mq.width,
                child: AddNewEmployeeButton(
                  isConnectionWorking: isConnectionWorking,
                  mq: mq,
                  formKey: _formKey,
                  textEditingController: _textEditingController,
                  appProvider: weekDaysProvider,
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
              child: isPortrait
                  ? ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        AddNewEmployeeTextField(
                          formKey: _formKey,
                          textEditingController: _textEditingController,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        ElevatedButtonTheme(
                          data: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: isPortrait
                                    ? mq.width * 0.05
                                    : mq.height * 0.05,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              backgroundColor: weekDaysProvider.errorState
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.background,
                              foregroundColor: weekDaysProvider.errorState
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: WorkingTimeSelectionWidget(
                            isPortrait: isPortrait,
                            fontSize:
                                isPortrait ? mq.width * 0.07 : mq.height * 0.07,
                            mq: mq,
                            workingFrom: workingFrom,
                            weekDaysProvider: weekDaysProvider,
                            workingTo: workingTo,
                          ),
                        ),
                        SizedBox(height: mq.height * 0.02),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: mq.height * 0.35,
                          ),
                          child: OffDaysSelectorWidget(
                            isPortrait: isPortrait,
                            weekDaysProvider: weekDaysProvider,
                            mq: mq,
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: mq.height * 0.5),
                          child: AllowedDelayWidget(
                            mq: mq,
                            isPortrait: true,
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),
                      ],
                    )
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        AddNewEmployeeTextField(
                          formKey: _formKey,
                          textEditingController: _textEditingController,
                        ),
                        SizedBox(
                          height: mq.height * 0.05,
                        ),
                        AspectRatio(
                          aspectRatio: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ElevatedButtonTheme(
                                  data: ElevatedButtonThemeData(
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(
                                        fontSize: isPortrait
                                            ? mq.width * 0.05
                                            : mq.height * 0.05,
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      backgroundColor:
                                          weekDaysProvider.errorState
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                      foregroundColor:
                                          weekDaysProvider.errorState
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                    ),
                                  ),
                                  child: WorkingTimeSelectionWidget(
                                    isPortrait: isPortrait,
                                    fontSize: isPortrait
                                        ? mq.width * 0.07
                                        : mq.height * 0.07,
                                    mq: mq,
                                    workingFrom: workingFrom,
                                    weekDaysProvider: weekDaysProvider,
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
                                  isPortrait: false,
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
                          weekDaysProvider: weekDaysProvider,
                          mq: mq,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
