import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/providers/app_provider.dart';
import '../../../domain/entities/employee.dart';
import '../../../other/network_problem_notifier.dart';
import '../../screens/edit_employee_details_screen.dart';
import '../../screens/excel_export_screen.dart';
import '../../screens/qr_code_screen.dart';

class EmployeeDetailsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmployeeDetailsScreenAppBar({
    Key? key,
    required this.isConnectionWorking,
    required this.weekDaysProvider,
    required this.employee,
    required this.mq,
  }) : super(key: key);

  final bool isConnectionWorking;
  final AppProvider weekDaysProvider;
  final Employee employee;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'بيانات الموظف',
        style: TextStyle(fontSize: mq.height * 0.025),
      ),
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
        IconButton(
          onPressed: !isConnectionWorking
              ? () => networkProblemNotifier(context)
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExcelExportScreen(
                        employee: employee,
                        isAllEmployee: false,
                      ),
                    ),
                  );
                },
          icon: Icon(
            FontAwesomeIcons.fileExport,
            color: isConnectionWorking ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(0, mq.height * 0.1);
}
