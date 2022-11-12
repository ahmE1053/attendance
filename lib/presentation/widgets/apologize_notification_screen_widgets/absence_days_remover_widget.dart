import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/app_provider.dart';
import '../../../domain/entities/employee.dart';

class AbsenceDaysRemoverWidget extends StatelessWidget {
  const AbsenceDaysRemoverWidget({
    Key? key,
    required this.mq,
    required this.employee,
    required this.appProvider,
    required this.format,
  }) : super(key: key);

  final Size mq;
  final Employee employee;
  final AppProvider? appProvider;
  final DateFormat format;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'برجاء اختيار الأيام لحذفها من سجل الموظف',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: mq.width * 0.07),
                    ),
                  ),
                  ...employee.absenceDaysList.map(
                    (e) {
                      final isDaySelected =
                          appProvider!.absenceDaysList.contains(e);
                      return CheckboxListTile(
                        value: isDaySelected,
                        onChanged: (value) {
                          if (value!) {
                            appProvider!.addToAbsenceDaysList(e);
                          } else {
                            appProvider!.removeFromAbsenceDaysList(e);
                          }
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        selected: isDaySelected,
                        activeColor: Theme.of(context).colorScheme.primary,
                        title: Text(
                          format.format(e),
                          style: TextStyle(
                            color: isDaySelected
                                ? Colors.grey
                                : Theme.of(context).colorScheme.onBackground,
                            fontSize: mq.width * 0.06,
                            decoration: isDaySelected
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
            SizedBox(
              height: mq.height * 0.05,
              child: ElevatedButton(
                onPressed: appProvider!.absenceDaysList.isEmpty
                    ? null
                    : () {
                        appProvider!.absenceRemoverDone = true;
                        Navigator.pop(context);
                      },
                child: const Text('موافق'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
