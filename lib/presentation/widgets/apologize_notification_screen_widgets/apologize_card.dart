import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/utilities/dependency_injection.dart';
import '../../../domain/entities/employee.dart';
import '../../../domain/use cases/remove_employee_absence_use_case.dart';
import 'absence_days_remover_widget.dart';

class ApologizeNotificationCard extends StatelessWidget {
  const ApologizeNotificationCard({
    Key? key,
    required this.employee,
    required this.isConnectionWorking,
    this.function,
    required this.expanded,
    this.appProvider,
  }) : super(key: key);
  final Employee employee;

  final void Function()? function;
  final bool expanded, isConnectionWorking;
  final AppProvider? appProvider;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final mq = mediaQuery.size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
      ),
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(
        vertical: mq.height * 0.015,
        horizontal: mq.width * 0.01,
      ),
      child: Builder(builder: (context) {
        if (isPortrait) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  employee.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: isPortrait ? mq.width * 0.07 : mq.height * 0.07,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  employee.apologyMessage,
                  style: TextStyle(
                    fontSize: isPortrait ? mq.width * 0.05 : mq.height * 0.05,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: mq.width * 0.35,
                    height: mq.height * 0.05,
                    child: ElevatedButton(
                      onPressed: !isConnectionWorking
                          ? null
                          : () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  context.watch<AppProvider>();
                                  final format = DateFormat.yMMMMd('ar-Eg');
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: AbsenceDaysRemoverWidget(
                                        mq: mq,
                                        employee: employee,
                                        appProvider: appProvider,
                                        format: format),
                                  );
                                },
                              );
                              if (appProvider!.absenceRemoverDone) {
                                await getIt
                                    .get<RemoveEmployeeAbsenceUseCase>()
                                    .run(true, employee,
                                        appProvider!.absenceDaysList.length);
                                (function ?? () {}).call();
                              }
                              appProvider!.absenceDaysList.clear();
                              appProvider!.absenceRemoverDone = false;
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: Text(
                        'قبول',
                        style: TextStyle(
                          color: !isConnectionWorking
                              ? Theme.of(context).colorScheme.onBackground
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: mq.width * 0.35,
                    height: mq.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: !isConnectionWorking
                          ? null
                          : () async {
                              await getIt
                                  .get<RemoveEmployeeAbsenceUseCase>()
                                  .run(false, employee, 0);
                              (function ?? () {}).call();
                            },
                      child: Text(
                        'رفض',
                        style: TextStyle(
                          color: !isConnectionWorking
                              ? Theme.of(context).colorScheme.onBackground
                              : Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        } else {
          return SizedBox(
            height: mq.height * 0.3,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          employee.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize:
                                isPortrait ? mq.width * 0.07 : mq.height * 0.07,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          employee.apologyMessage,
                          style: TextStyle(
                            fontSize:
                                isPortrait ? mq.width * 0.05 : mq.height * 0.05,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: !isConnectionWorking
                              ? null
                              : () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      context.watch<AppProvider>();
                                      final format = DateFormat.yMMMMd('ar-Eg');
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: AbsenceDaysRemoverWidget(
                                            mq: mq,
                                            employee: employee,
                                            appProvider: appProvider,
                                            format: format),
                                      );
                                    },
                                  );
                                  if (appProvider!.absenceRemoverDone) {
                                    await getIt
                                        .get<RemoveEmployeeAbsenceUseCase>()
                                        .run(
                                            true,
                                            employee,
                                            appProvider!
                                                .absenceDaysList.length);
                                    (function ?? () {}).call();
                                  }
                                  appProvider!.absenceDaysList.clear();
                                  appProvider!.absenceRemoverDone = false;
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: Text(
                            'قبول',
                            style: TextStyle(
                              color: !isConnectionWorking
                                  ? Theme.of(context).colorScheme.onBackground
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mq.height * 0.05),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: !isConnectionWorking
                              ? null
                              : () async {
                                  await getIt
                                      .get<RemoveEmployeeAbsenceUseCase>()
                                      .run(false, employee, 0);
                                  (function ?? () {}).call();
                                },
                          child: Text(
                            'رفض',
                            style: TextStyle(
                              color: !isConnectionWorking
                                  ? Theme.of(context).colorScheme.onBackground
                                  : Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
