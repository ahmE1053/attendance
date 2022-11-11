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
  }) : super(key: key);

  final Size mq;
  final bool isDarkMode;
  final ColorScheme colorScheme;
  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FittedBox(
          alignment: Alignment.centerRight,
          fit: BoxFit.scaleDown,
          child: Text(
            'بيانات حضور وانصراف الموظف السابقة',
            style: TextStyle(
              fontSize: mq.width * 0.07,
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
                : ListView.builder(
                    itemCount: employee.detailedReport.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'اليوم',
                                    style: TextStyle(
                                      fontSize: mq.width * 0.07,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'الحالة',
                                    style: TextStyle(
                                      fontSize: mq.width * 0.07,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'الحضور',
                                    style: TextStyle(
                                      fontSize: mq.width * 0.07,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'الانصراف',
                                    style: TextStyle(
                                      fontSize: mq.width * 0.07,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final detailedReportForDay =
                          employee.detailedReport[index - 1];
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
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  finalCurrentDay,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: mq.width * 0.07,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  detailedReportForDay['todayState'],
                                  style: TextStyle(
                                    fontSize: mq.width * 0.07,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (checkIfAbsentOrOnVacation) ...[
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    detailedReportForDay[
                                        'currentDayWorkingFrom'],
                                    style: TextStyle(
                                      fontSize: mq.width * 0.07,
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
                                    detailedReportForDay['currentDayWorkingTo'],
                                    style: TextStyle(
                                      fontSize: mq.width * 0.07,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (!checkIfAbsentOrOnVacation)
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'لا يوجد',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: mq.width * 0.07,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
