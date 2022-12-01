import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/utilities/dependency_injection.dart';
import '../../../domain/entities/employee.dart';
import '../../../domain/use cases/delete_employee.dart';
import '../../../other/network_problem_notifier.dart';
import '../../screens/edit_employee_details_screen.dart';
import '../../screens/employees_screen.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      title: Text(
        'بيانات الموظف',
        style: TextStyle(fontSize: mq.height * 0.025),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.edit,
                  color: isConnectionWorking
                      ? colorScheme.onBackground
                      : Colors.grey,
                ),
                title: Text(
                  'تعديل',
                  style: TextStyle(
                    color: isConnectionWorking
                        ? colorScheme.onBackground
                        : Colors.grey,
                  ),
                ),
                onTap: !isConnectionWorking
                    ? () => networkProblemNotifier(context)
                    : () {
                        weekDaysProvider.workingFrom = employee.workingFrom;
                        weekDaysProvider.workingTo = employee.workingTo;
                        weekDaysProvider.editWeekDays(employee.offDays);
                        weekDaysProvider
                            .vacationDaysSetter(employee.vacationDays);
                        weekDaysProvider
                            .allowedDelayParser(employee.allowedDelay);
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
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.qr_code_2,
                  color: isConnectionWorking
                      ? colorScheme.onBackground
                      : Colors.grey,
                ),
                title: Text(
                  'كود ال Qr',
                  style: TextStyle(
                    color: isConnectionWorking
                        ? colorScheme.onBackground
                        : Colors.grey,
                  ),
                ),
                onTap: !isConnectionWorking
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
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.fileExport,
                  color: isConnectionWorking
                      ? colorScheme.onBackground
                      : Colors.grey,
                ),
                title: Text(
                  'إلى ملف Excel',
                  style: TextStyle(
                    color: isConnectionWorking
                        ? colorScheme.onBackground
                        : Colors.grey,
                  ),
                ),
                onTap: !isConnectionWorking
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
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                  color: isConnectionWorking
                      ? colorScheme.onBackground
                      : Colors.grey,
                ),
                title: Text(
                  'حذف',
                  style: TextStyle(
                    color: isConnectionWorking
                        ? colorScheme.onBackground
                        : Colors.grey,
                  ),
                ),
                onTap: !isConnectionWorking
                    ? () => networkProblemNotifier(context)
                    : () {
                        Alert(
                          context: context,
                          buttons: [
                            DialogButton(
                              color: Colors.greenAccent,
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                final scaffold = ScaffoldMessenger.of(context);
                                await getIt
                                    .get<DeleteEmployeeUseCase>()
                                    .run(employee);
                                navigator.pushNamedAndRemoveUntil(
                                    GeneralEmployeesScreen.id,
                                    (route) => false);
                                scaffold.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'تم الحذف بنجاح',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'نعم',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            DialogButton(
                              color: Colors.redAccent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'لا',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          type: AlertType.warning,
                          style: AlertStyle(
                            titleStyle: TextStyle(
                              color: colorScheme.onBackground,
                            ),
                            descStyle: TextStyle(
                              color: colorScheme.onBackground,
                            ),
                          ),
                          title: 'تحذير',
                          desc:
                              'حذف الموظف سيقوم بمسح كل بياناته\n لا يمكنك الرجوع في هذا الأمر',
                        ).show();
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(0, mq.height * 0.1);
}
