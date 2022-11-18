import 'package:flutter/material.dart';

import '../../../core/providers/app_provider.dart';

class WorkingTimeSelectionWidget extends StatelessWidget {
  const WorkingTimeSelectionWidget({
    Key? key,
    required this.mq,
    required this.workingFrom,
    required this.weekDaysProvider,
    required this.workingTo,
    required this.isPortrait,
    required this.fontSize,
  }) : super(key: key);

  final Size mq;
  final bool isPortrait;
  final TimeOfDay? workingFrom;
  final double fontSize;
  final AppProvider weekDaysProvider;
  final TimeOfDay? workingTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isPortrait
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'مواعيد حضور وانصرف الموظف',
                    style: TextStyle(
                      fontSize: mq.width * 0.07,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.02),
                WorkingTimeWidget(
                  fontSize: fontSize,
                  isPortrait: isPortrait,
                  toOrFrom: false,
                  mq: mq,
                  timeOfDay: workingFrom,
                  weekDaysProvider: weekDaysProvider,
                  text: 'موعد حضور الموظف',
                ),
                SizedBox(height: mq.height * 0.02),
                WorkingTimeWidget(
                  fontSize: fontSize,
                  isPortrait: isPortrait,
                  toOrFrom: true,
                  mq: mq,
                  timeOfDay: workingTo,
                  weekDaysProvider: weekDaysProvider,
                  text: 'موعد انصراف الموظف',
                ),
              ],
            )
          : Column(
              children: [
                FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'مواعيد حضور وانصرف الموظف',
                    style: TextStyle(
                      fontSize: mq.height * 0.07,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.03),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: WorkingTimeWidget(
                          fontSize: fontSize,
                          isPortrait: isPortrait,
                          toOrFrom: false,
                          mq: mq,
                          timeOfDay: workingFrom,
                          weekDaysProvider: weekDaysProvider,
                          text: 'موعد حضور الموظف',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: WorkingTimeWidget(
                          fontSize: fontSize,
                          isPortrait: isPortrait,
                          toOrFrom: true,
                          mq: mq,
                          timeOfDay: workingTo,
                          weekDaysProvider: weekDaysProvider,
                          text: 'موعد انصراف الموظف',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class WorkingTimeWidget extends StatelessWidget {
  const WorkingTimeWidget({
    Key? key,
    required this.timeOfDay,
    required this.weekDaysProvider,
    required this.text,
    required this.mq,
    required this.toOrFrom,
    required this.isPortrait,
    required this.fontSize,
  }) : super(key: key);
  final TimeOfDay? timeOfDay;
  final String text;
  final double fontSize;
  final bool toOrFrom, isPortrait;
  final AppProvider weekDaysProvider;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    final buttonSize = isPortrait ? mq.width * .15 : mq.height * .15;
    if (timeOfDay == null) {
      return SizedBox(
        height: buttonSize,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () async {
            FocusManager.instance.primaryFocus!.unfocus();
            await weekDaysProvider.editWorkingHours(context, toOrFrom);
          },
          child: FittedBox(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      );
    } else {
      return isPortrait
          ? Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$text:',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: mq.width * 0.3,
                  height: mq.height * 0.1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: FittedBox(
                    child: Text(
                      weekDaysProvider.getCorrectTimeText(
                        timeOfDay!,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    weekDaysProvider.editWorkingHours(context, toOrFrom);
                  },
                  child: Container(
                    width: mq.width * 0.1,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    padding: EdgeInsets.all(mq.width * .02),
                    child: const FittedBox(
                      child: Icon(
                        Icons.edit,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            )
          : GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                weekDaysProvider.editWorkingHours(context, toOrFrom);
              },
              child: Container(
                height: mq.height * 0.3,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                  child: Text(
                    weekDaysProvider.getCorrectTimeText(
                      timeOfDay!,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            );
    }
  }
}
