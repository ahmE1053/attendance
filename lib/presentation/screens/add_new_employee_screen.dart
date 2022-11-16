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
    final mq = MediaQuery.of(context).size;
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;

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
                height: mq.height * 0.07,
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
                isConnectionWorking ? 0 : mq.height * 0.07,
              ),
            ],
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(30),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        AddNewEmployeeTextField(
                          formKey: _formKey,
                          textEditingController: _textEditingController,
                        ),
                        ElevatedButtonTheme(
                          data: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: mq.width * 0.05,
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
                            mq: mq,
                            workingFrom: workingFrom,
                            weekDaysProvider: weekDaysProvider,
                            workingTo: workingTo,
                          ),
                        ),
                        OffDaysSelectorWidget(
                          weekDaysProvider: weekDaysProvider,
                          mq: mq,
                        ),
                        AllowedDelayWidget(mq: mq),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
