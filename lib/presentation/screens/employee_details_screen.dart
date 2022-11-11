import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../../domain/entities/employee.dart';
import '../../other/minutes_text_adjuster.dart';
import '../widgets/employee_details_screen/employee_details_report.dart';
import 'edit_employee_details_screen.dart';
import 'qr_code_screen.dart';

class EmployeeInfoScreen extends StatelessWidget {
  static const id = 'EmployeeInfoScreen';
  final Employee employee;

  const EmployeeInfoScreen({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final weekDaysProvider = Provider.of<AppProvider>(context, listen: false);
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات الموظف'),
        actions: [
          IconButton(
            onPressed: () {
              weekDaysProvider.workingFrom = employee.workingFrom;
              weekDaysProvider.workingTo = employee.workingTo;
              weekDaysProvider.editWeekDays(employee.offDays);
              weekDaysProvider.vacationDaysSetter(employee.vacationDays);
              weekDaysProvider.allowedDelayParser(employee.allowedDelay);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EditEmployeeDetailsScreen(
                      textEditingController:
                          TextEditingController(text: employee.name),
                      appProvider: weekDaysProvider,
                      employee: employee,
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QrCodeScreen(
                    name: employee.name,
                    id: employee.id,
                    firstTime: false,
                    downloadUrl: employee.downloadUrl,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.qr_code_2,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: DefaultTextStyle(
          style: GoogleFonts.cairo(
            color: colorScheme.onBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: employee.id,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          employee.name,
                          style: TextStyle(
                            fontSize: mq.width * 0.09,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * 0.01,
                    ),
                    Text(
                      minutesTextAdjustor(employee.lateInMinutes),
                      style: TextStyle(fontSize: mq.width * 0.05),
                    ),
                    Text(
                      absenceDaysTextAdjustor(employee.absenceDays),
                      style: TextStyle(fontSize: mq.width * 0.05),
                    ),
                    if (employee.employeeState == 'خارج ساعات العمل' &&
                        employee.currentDayWorkingFrom != null &&
                        employee.currentDayWorkingTo != null) ...[
                      Divider(
                        indent: mq.width * 0.1,
                        endIndent: mq.width * 0.1,
                        color: colorScheme.onBackground,
                        thickness: 5,
                      ),
                      Text(
                        employeeWorkingTimeAdjustor(
                          employee.currentDayWorkingFrom!,
                          'حضور',
                        ),
                        style: TextStyle(fontSize: mq.width * 0.05),
                      ),
                      Text(
                        employeeWorkingTimeAdjustor(
                          employee.currentDayWorkingTo!,
                          'انصراف',
                        ),
                        style: TextStyle(fontSize: mq.width * 0.05),
                      ),
                    ],
                    if (employee.employeeState == 'حاضر') ...[
                      Divider(
                        indent: mq.width * 0.1,
                        endIndent: mq.width * 0.1,
                        color: colorScheme.onBackground,
                        thickness: 5,
                      ),
                      Text(
                        employeeWorkingTimeAdjustor(
                          employee.currentDayWorkingFrom!,
                          'حضور',
                        ),
                        style: TextStyle(fontSize: mq.width * 0.05),
                      ),
                    ],
                    Divider(
                      endIndent: mq.width * 0.25,
                      thickness: 2,
                      color: colorScheme.onBackground,
                      indent: mq.width * 0.25,
                    ),
                    Text(
                      vacationDaysTextAdjustor(employee.vacationDays.length),
                      style: TextStyle(
                        fontSize: mq.width * 0.06,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (employee.vacationDays.length <= 3)
                      ...employee.vacationDays.map(
                        (vacationDay) {
                          final String formattedDayInArabic =
                              DateFormat.yMMMMEEEEd('ar').format(vacationDay);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '  • $formattedDayInArabic',
                                  style: TextStyle(
                                    fontSize: mq.width * 0.05,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    if (employee.vacationDays.length > 3)
                      SizedBox(
                        height: mq.width * 0.25,
                        child: ListView.separated(
                          itemBuilder: (_, index) {
                            final formattedDayInArabic =
                                DateFormat.yMMMMEEEEd('ar')
                                    .format(employee.vacationDays[index]);
                            return Text(
                              '  • $formattedDayInArabic',
                              style: TextStyle(
                                fontSize: mq.width * 0.05,
                              ),
                            );
                          },
                          itemCount: employee.vacationDays.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              endIndent: mq.width * 0.25,
                              thickness: 2,
                              indent: mq.width * 0.25,
                              color: colorScheme.onBackground,
                            );
                          },
                        ),
                      ),
                  ],
                ),
                Divider(
                  endIndent: mq.width * 0.25,
                  thickness: 2,
                  indent: mq.width * 0.25,
                  color: colorScheme.onBackground,
                ),
                Expanded(
                  child: EmployeeDetailsReport(
                      mq: mq,
                      isDarkMode: isDarkMode,
                      colorScheme: colorScheme,
                      employee: employee),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
