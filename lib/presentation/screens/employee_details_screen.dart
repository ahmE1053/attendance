import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../../core/providers/network_provider.dart';
import '../../domain/entities/employee.dart';
import '../widgets/employee_details_screen_widgets/exports.dart';
import '../widgets/no_connection_bottom_bar.dart';

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
          mq: mq,
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
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isPortrait = orientation == Orientation.portrait;
                final fontSize =
                    isPortrait ? mq.width * 0.06 : mq.height * 0.07;
                if (isPortrait) {
                  return Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: mq.height * 0.25,
                        ),
                        child: EmployeeDetailsScreenInfo(
                            employee: employee,
                            fontSize: fontSize,
                            colorScheme: colorScheme,
                            mq: mq),
                      ),
                      Divider(
                        endIndent: mq.width * 0.25,
                        thickness: 2,
                        indent: mq.width * 0.25,
                        color: colorScheme.onBackground,
                      ),
                      Expanded(
                        flex: 4,
                        child: EmployeeDetailsReport(
                          isPortrait: true,
                          mq: mq,
                          isDarkMode: isDarkMode,
                          colorScheme: colorScheme,
                          employee: employee,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: EmployeeDetailsScreenInfo(
                          employee: employee,
                          fontSize: fontSize,
                          colorScheme: colorScheme,
                          mq: mq,
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
