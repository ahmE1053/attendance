import 'package:flutter/material.dart';

import '../../../core/other/employee_state_color_getter.dart';
import '../../../domain/entities/employee.dart';
import '../../screens/employee_details_screen.dart';

class EmployeesScreenTableEntryWidget extends StatelessWidget {
  const EmployeesScreenTableEntryWidget({
    Key? key,
    required this.employee,
    required this.mq,
  }) : super(key: key);

  final Employee employee;
  final Size mq;

  @override
  Widget build(BuildContext context) {
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
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'Cairo',
          color: Colors.black,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Hero(
                    tag: employee.id,
                    child: Material(
                      type: MaterialType.transparency, // likely needed
                      child: Text(
                        employee.name,
                        style: TextStyle(
                          fontSize: mq.width * 0.07,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    employee.lateInMinutes.toString(),
                    style: TextStyle(
                      fontSize: mq.width * 0.07,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    employee.absenceDays.toString(),
                    style: TextStyle(
                      fontSize: mq.width * 0.07,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: employeeStateColorGetter(
                      employee.employeeState,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      employee.employeeState == 'خارج ساعات العمل'
                          ? 'خارج ساعات\nالعمل'
                          : employee.employeeState,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: mq.width * 0.07,
                        color: employee.employeeState == 'غائب'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
