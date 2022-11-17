import 'package:attendance/core/other/employee_state_color_getter.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/employee.dart';
import '../../screens/employee_details_screen.dart';

class TableEntryLandscape extends StatelessWidget {
  const TableEntryLandscape({
    Key? key,
    required this.employee,
    required this.mq,
  }) : super(key: key);

  final Employee employee;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    final color = employeeStateColorGetter(employee.employeeState);
    final colorScheme = ColorScheme.fromSeed(seedColor: color);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmployeeInfoScreen(
              employee: employee,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              'الاسم: ${employee.name}',
              style: TextStyle(
                fontSize: mq.width * 0.06,
                color: colorScheme.onPrimary,
              ),
            ),
            Text(
              'التأخر: ${employee.lateInMinutes}',
              style: TextStyle(
                fontSize: mq.width * 0.06,
                color: colorScheme.onPrimary,
              ),
            ),
            Text(
              'الغياب: ${employee.absenceDays}',
              style: TextStyle(
                fontSize: mq.width * 0.06,
                color: colorScheme.onPrimary,
              ),
            ),
            Text(
              employee.employeeState,
              style: TextStyle(
                fontSize: mq.width * 0.06,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
