import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/employee.dart';

class EmployeeDetailsReport extends StatelessWidget {
  const EmployeeDetailsReport({
    Key? key,
    required this.mq,
    required this.isDarkMode,
    required this.colorScheme,
    required this.employee,
    required this.isPortrait,
  }) : super(key: key);

  final Size mq;

  final bool isDarkMode, isPortrait;
  final ColorScheme colorScheme;
  final Employee employee;

  @override
  Widget build(BuildContext context) {
    final fontSize = isPortrait ? mq.width * 0.05 : mq.height * 0.05;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FittedBox(
          alignment: Alignment.centerRight,
          fit: BoxFit.scaleDown,
          child: Text(
            'بيانات حضور وانصراف الموظف السابقة',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color:
                  isDarkMode ? colorScheme.onBackground : colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.only(
              bottom: mq.height * 0.03,
              left: mq.width * 0.02,
              right: mq.width * 0.02,
            ),
            child: employee.detailedReport.isEmpty
                ? FittedBox(
                    child: Text(
                      'لا توجد بيانات للموظف حتى الآن',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Align(
                                child: SizedBox(
                                  width: isPortrait
                                      ? mq.height * 0.06
                                      : mq.width * 0.06,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'اليوم',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Align(
                                child: SizedBox(
                                  width: isPortrait
                                      ? mq.height * 0.06
                                      : mq.width * 0.06,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'الحالة',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Align(
                                child: SizedBox(
                                  width: isPortrait
                                      ? mq.height * 0.06
                                      : mq.width * 0.06,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'الحضور',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Align(
                                child: SizedBox(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'الانصراف',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: employee.detailedReport.length,
                          itemBuilder: (context, index) {
                            final detailedReportForDay =
                                employee.detailedReport[index];
                            final formatDay = DateFormat.E('ar-EG');
                            final formatRest = DateFormat.yMMMMd('ar-EG');
                            final currentDayInReport = formatDay.format(
                              (detailedReportForDay['currentDay'] as Timestamp)
                                  .toDate(),
                            );
                            final currentDateInReport = formatRest.format(
                              (detailedReportForDay['currentDay'] as Timestamp)
                                  .toDate(),
                            );
                            final finalCurrentDay =
                                '$currentDayInReport\n$currentDateInReport';
                            final bool checkIfAbsentOrOnVacation =
                                detailedReportForDay['todayState'] == 'حاضر';
                            return Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isDarkMode
                                    ? colorScheme.background
                                    : colorScheme.onPrimary,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        finalCurrentDay,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        detailedReportForDay['todayState'],
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  if (checkIfAbsentOrOnVacation) ...[
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          detailedReportForDay[
                                              'currentDayWorkingFrom'],
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          detailedReportForDay[
                                              'currentDayWorkingTo'],
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (!checkIfAbsentOrOnVacation)
                                    Expanded(
                                      flex: 2,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'لا يوجد',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
