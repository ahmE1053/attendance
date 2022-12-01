import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/providers/theme_provider.dart';
import '../../../domain/entities/employee.dart';
import '../../../other/network_problem_notifier.dart';
import '../../screens/apologize_notification_screen.dart';
import '../../screens/excel_export_screen.dart';
import '../../screens/zoom_drawer.dart';

class EmployeesScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmployeesScreenAppBar({
    super.key,
    required this.themeProvider,
    required this.isLoaded,
    required this.isConnectionWorking,
    required this.employeesList,
  });

  final ThemeProvider themeProvider;
  final bool isLoaded;
  final bool isConnectionWorking;
  final List<Employee> employeesList;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.list),
        onPressed: () {
          zoomDrawerController.open!();
        },
      ),
      actions: [
        Tooltip(
          message: themeProvider.darkMode
              ? 'إلغاء الوضع الليلي'
              : 'تفعيل الوضع الليلي',
          child: IconButton(
            onPressed: () async {
              await themeProvider.changeMode();
            },
            icon: themeProvider.darkMode
                ? const Icon(
                    Icons.sunny,
                  )
                : const Icon(
                    Icons.nightlight_round_sharp,
                  ),
          ),
        ),
        if (isLoaded)
          Tooltip(
            message: 'الأعذار للغياب',
            child: IconButton(
              onPressed: !isConnectionWorking
                  ? () => networkProblemNotifier(context)
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApologizeNotificationScreen(
                            employeesList: employeesList
                                .where(
                                    (element) => element.isApologizing == true)
                                .toList(),
                          ),
                        ),
                      );
                    },
              icon: Badge(
                badgeContent: Text(
                  employeesList
                      .where((element) => element.isApologizing == true)
                      .length
                      .toString(),
                ),
                position: BadgePosition.topStart(),
                showBadge: employeesList
                    .where((element) => element.isApologizing == true)
                    .isNotEmpty,
                child: Icon(
                  Icons.email,
                  color: isConnectionWorking ? Colors.white : Colors.grey,
                ),
              ),
            ),
          )
        else
          const SpinKitDoubleBounce(
            color: Colors.white,
          ),
        Tooltip(
          message: 'تحميل بيانات الموظفين على هيئة ملف Excel',
          child: IconButton(
            onPressed: !isConnectionWorking
                ? () => networkProblemNotifier(context)
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExcelExportScreen(
                          employeesList: employeesList,
                          isAllEmployee: true,
                        ),
                      ),
                    );
                  },
            icon: Icon(
              FontAwesomeIcons.fileExport,
              color: isConnectionWorking ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ],
      title: const Text('الموظفين'),
    );
  }

  @override
  Size get preferredSize => Size(0, AppBar().preferredSize.height);
}
