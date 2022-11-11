import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../widgets/adding_new_employee_screen_folder/add_new_employee_button.dart';
import '../widgets/adding_new_employee_screen_folder/add_new_employee_text_field_widget.dart';
import '../widgets/adding_new_employee_screen_folder/off_days_selector_widget.dart';
import '../widgets/adding_new_employee_screen_folder/working_time_widget.dart';
import '../widgets/allowed_delay_widget.dart';

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
          bottomNavigationBar: SizedBox(
            height: mq.height * 0.07,
            width: mq.width,
            child: AddNewEmployeeButton(
              mq: mq,
              formKey: _formKey,
              textEditingController: _textEditingController,
              appProvider: weekDaysProvider,
            ),
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
                              textStyle: GoogleFonts.cairo(
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
