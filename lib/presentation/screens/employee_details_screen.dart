import 'package:attendance/other/network_problem_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../../core/providers/network_provider.dart';
import '../../domain/entities/employee.dart';
import '../../other/minutes_text_adjuster.dart';
import '../widgets/employee_details_screen_widgets/employee_details_report.dart';
import '../widgets/no_connection_bottom_bar.dart';
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
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;
    return Scaffold(
      bottomNavigationBar: NoConnectionBottomBar(
        isConnectionWorking ? 0 : mq.height * 0.07,
      ),
      appBar: EmployeeDetailsScreenAppBar(
          isConnectionWorking: isConnectionWorking,
          weekDaysProvider: weekDaysProvider,
          employee: employee),
      body: SafeArea(
        child: DefaultTextStyle(
          style: TextStyle(
            color: colorScheme.onBackground,
            fontFamily: 'Cairo',
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: OrientationBuilder(builder: (context, orientation) {
              final isPortrait = orientation == Orientation.portrait;
              final fontSize = isPortrait ? mq.width * 0.08 : mq.height * 0.08;
              if (isPortrait) {
                return Column(
                  children: [
                    Column(
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
                          vacationDaysTextAdjustor(
                              employee.vacationDays.length),
                          style: TextStyle(
                            fontSize: mq.width * 0.06,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (employee.vacationDays.length <= 3)
                          ...employee.vacationDays.map(
                            (vacationDay) {
                              final String formattedDayInArabic =
                                  DateFormat.yMMMMEEEEd('ar')
                                      .format(vacationDay);
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
                          isPortrait: true,
                          mq: mq,
                          isDarkMode: isDarkMode,
                          colorScheme: colorScheme,
                          employee: employee),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Hero(
                            tag: employee.id,
                            child: Material(
                              type: MaterialType.transparency,
                              child: FittedBox(
                                alignment: Alignment.centerRight,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  employee.name,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w900,
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: mq.height * 0.01,
                          ),
                          FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              minutesTextAdjustor(employee.lateInMinutes),
                              style: TextStyle(fontSize: mq.width * 0.05),
                            ),
                          ),
                          FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              absenceDaysTextAdjustor(employee.absenceDays),
                              style: TextStyle(fontSize: mq.width * 0.05),
                            ),
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
                            FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                employeeWorkingTimeAdjustor(
                                  employee.currentDayWorkingFrom!,
                                  'حضور',
                                ),
                                style: TextStyle(fontSize: mq.width * 0.05),
                              ),
                            ),
                            FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                employeeWorkingTimeAdjustor(
                                  employee.currentDayWorkingTo!,
                                  'انصراف',
                                ),
                                style: TextStyle(fontSize: mq.width * 0.05),
                              ),
                            ),
                          ],
                          if (employee.employeeState == 'حاضر') ...[
                            Divider(
                              indent: mq.width * 0.1,
                              endIndent: mq.width * 0.1,
                              color: colorScheme.onBackground,
                              thickness: 5,
                            ),
                            FittedBox(
                              child: Text(
                                employeeWorkingTimeAdjustor(
                                  employee.currentDayWorkingFrom!,
                                  'حضور',
                                ),
                                style: TextStyle(fontSize: mq.width * 0.05),
                              ),
                            ),
                          ],
                          Divider(
                            endIndent: mq.width * 0.25,
                            thickness: 2,
                            color: colorScheme.onBackground,
                            indent: mq.width * 0.25,
                          ),
                          FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              vacationDaysTextAdjustor(
                                  employee.vacationDays.length),
                              style: TextStyle(
                                fontSize: mq.width * 0.06,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (employee.vacationDays.length <= 3)
                            ...employee.vacationDays.map(
                              (vacationDay) {
                                final String formattedDayInArabic =
                                    DateFormat.yMMMMEEEEd('ar')
                                        .format(vacationDay);
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
                                  return FittedBox(
                                    alignment: Alignment.centerRight,
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '  • $formattedDayInArabic',
                                      style: TextStyle(
                                        fontSize: mq.width * 0.05,
                                      ),
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
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: EmployeeDetailsReport(
                          isPortrait: false,
                          mq: mq,
                          isDarkMode: isDarkMode,
                          colorScheme: colorScheme,
                          employee: employee),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}

class EmployeeDetailsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmployeeDetailsScreenAppBar({
    Key? key,
    required this.isConnectionWorking,
    required this.weekDaysProvider,
    required this.employee,
  }) : super(key: key);

  final bool isConnectionWorking;
  final AppProvider weekDaysProvider;
  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('بيانات الموظف'),
      actions: [
        IconButton(
          onPressed: !isConnectionWorking
              ? () => networkProblemNotifier(context)
              : () {
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
          icon: Icon(
            Icons.edit,
            color: isConnectionWorking ? Colors.white : Colors.grey,
          ),
        ),
        IconButton(
          onPressed: !isConnectionWorking
              ? () => networkProblemNotifier(context)
              : () {
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
          icon: Icon(
            Icons.qr_code_2,
            color: isConnectionWorking ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(0, AppBar().preferredSize.height);
}
