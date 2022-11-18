import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/employee.dart';
import '../../../other/minutes_text_adjuster.dart';

class EmployeeDetailsScreenInfo extends StatelessWidget {
  const EmployeeDetailsScreenInfo({
    Key? key,
    required this.employee,
    required this.fontSize,
    required this.colorScheme,
    required this.mq,
  }) : super(key: key);

  final Employee employee;
  final double fontSize;
  final ColorScheme colorScheme;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
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
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ),
        FittedBox(
          alignment: Alignment.centerRight,
          fit: BoxFit.scaleDown,
          child: Text(
            absenceDaysTextAdjustor(employee.absenceDays),
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ),
        if (employee.employeeState == 'خارج ساعات العمل' &&
            employee.currentDayWorkingFrom != null &&
            employee.currentDayWorkingTo != null) ...[
          Divider(
            indent: mq.width * 0.25,
            endIndent: mq.width * 0.25,
            color: colorScheme.onBackground,
            thickness: 2,
          ),
          FittedBox(
            alignment: Alignment.centerRight,
            fit: BoxFit.scaleDown,
            child: Text(
              employeeWorkingTimeAdjustor(
                employee.currentDayWorkingFrom!,
                'حضور',
              ),
              style: TextStyle(fontSize: fontSize),
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
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
        if (employee.employeeState == 'حاضر') ...[
          Divider(
            indent: mq.width * 0.25,
            endIndent: mq.width * 0.25,
            color: colorScheme.onBackground,
            thickness: 2,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              employeeWorkingTimeAdjustor(
                employee.currentDayWorkingFrom!,
                'حضور',
              ),
              style: TextStyle(fontSize: fontSize),
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
            vacationDaysTextAdjustor(employee.vacationDays.length),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ...employee.vacationDays.asMap().entries.map(
          (vacationDayMapEntry) {
            final vacationDay = vacationDayMapEntry.value;
            final index = vacationDayMapEntry.key;
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
                      fontSize: fontSize,
                    ),
                  ),
                ),
                if (index != employee.vacationDays.length - 1)
                  Divider(
                    endIndent: mq.width * 0.25,
                    thickness: 2,
                    color: colorScheme.onBackground,
                    indent: mq.width * 0.25,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
