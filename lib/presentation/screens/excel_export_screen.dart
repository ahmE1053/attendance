import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/excel_provider.dart';
import '../../core/providers/network_provider.dart';
import '../../domain/entities/employee.dart';
import '../widgets/no_connection_bottom_bar.dart';

class ExcelExportScreen extends StatelessWidget {
  const ExcelExportScreen({
    Key? key,
    this.employee,
    this.employeesList,
    required this.isAllEmployee,
  }) : super(key: key);

  final Employee? employee;
  final List<Employee>? employeesList;
  final bool isAllEmployee;

  void saveFileFunction(
      BuildContext context, ExcelProvider excelProvider) async {
    final scaffold = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final downloadUrl = !isAllEmployee
        ? await excelProvider.saveExcelFile(employee!)
        : await excelProvider.saveExcelFileAllEmployees(employeesList!);
    final url = Uri.parse(downloadUrl);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text(
            'حدث خطأ، برجاء إعادة المحاولة والتأكد من موجود متصفح على الهاتف',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    navigator.pop();
    scaffold.showSnackBar(
      SnackBar(
        content: const Text(
          'تم حفظ الملف بنجاح على هاتفك',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final excelProvider = Provider.of<ExcelProvider>(context);
    final isConnectionWorking =
        Provider.of<NetworkProvider>(context).isConnectionWorking;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تحميل ملف Excel',
        ),
      ),
      bottomNavigationBar: NoConnectionBottomBar(
        isConnectionWorking ? 0 : mq.height * 0.07,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.2),
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/excel.gif',
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  FittedBox(
                    child: Text(
                      !isAllEmployee
                          ? 'تحميل بيانات الموظف السابقة \n على هيئة ملف Excel'
                          : 'تحميل بيانات الموظفين\n على هيئة ملف Excel',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  SizedBox(
                    height: mq.height * 0.07,
                    child: ElevatedButton(
                      //checks the connection first then checks if its for all employees or one employees
                      onPressed: !isConnectionWorking
                          ? null
                          : isAllEmployee
                              ? employeesList!.isEmpty
                                  ? null
                                  : () {
                                      saveFileFunction(
                                        context,
                                        excelProvider,
                                      );
                                    }
                              : employee!.detailedReport.isNotEmpty
                                  ? () {
                                      saveFileFunction(
                                        context,
                                        excelProvider,
                                      );
                                    }
                                  : null,
                      child: excelProvider.loading
                          ? CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : Text(
                              isAllEmployee
                                  ? employeesList!.isEmpty
                                      ? 'لا يوجد موظفين'
                                      : 'تحميل'
                                  : employee!.detailedReport.isNotEmpty
                                      ? 'تحميل'
                                      : 'لا يوجد بيانات سابقة للموظف',
                            ),
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/excel.gif',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FittedBox(
                          child: Text(
                            !isAllEmployee
                                ? 'تحميل بيانات الموظف السابقة \n على هيئة ملف Excel'
                                : 'تحميل بيانات الموظفين\n على هيئة ملف Excel',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.05,
                        ),
                        SizedBox(
                          height: mq.height * 0.07,
                          child: ElevatedButton(
                            //checks the connection first then checks if its for all employees or one employees
                            onPressed: !isConnectionWorking
                                ? null
                                : isAllEmployee
                                    ? employeesList!.isEmpty
                                        ? null
                                        : () {
                                            saveFileFunction(
                                              context,
                                              excelProvider,
                                            );
                                          }
                                    : employee!.detailedReport.isNotEmpty
                                        ? () {
                                            saveFileFunction(
                                              context,
                                              excelProvider,
                                            );
                                          }
                                        : null,
                            child: excelProvider.loading
                                ? CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                : Text(
                                    isAllEmployee
                                        ? employeesList!.isEmpty
                                            ? 'لا يوجد موظفين'
                                            : 'تحميل'
                                        : employee!.detailedReport.isNotEmpty
                                            ? 'تحميل'
                                            : 'لا يوجد بيانات سابقة للموظف',
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
