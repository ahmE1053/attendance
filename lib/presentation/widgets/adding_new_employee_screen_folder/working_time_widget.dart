import 'package:flutter/material.dart';

import '../../../core/providers/app_provider.dart';

class WorkingTimeSelectionWidget extends StatelessWidget {
  const WorkingTimeSelectionWidget({
    Key? key,
    required this.mq,
    required this.workingFrom,
    required this.weekDaysProvider,
    required this.workingTo,
  }) : super(key: key);

  final Size mq;
  final TimeOfDay? workingFrom;
  final AppProvider weekDaysProvider;
  final TimeOfDay? workingTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
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
            toOrFrom: false,
            mq: mq,
            timeOfDay: workingFrom,
            weekDaysProvider: weekDaysProvider,
            text: 'موعد حضور الموظف',
          ),
          SizedBox(height: mq.height * 0.02),
          WorkingTimeWidget(
            toOrFrom: true,
            mq: mq,
            timeOfDay: workingTo,
            weekDaysProvider: weekDaysProvider,
            text: 'موعد انصراف الموظف',
          ),
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
  }) : super(key: key);
  final TimeOfDay? timeOfDay;
  final String text;
  final bool toOrFrom;
  final AppProvider weekDaysProvider;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    if (timeOfDay == null) {
      return SizedBox(
        height: mq.width * .15,
        child: ElevatedButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus!.unfocus();

            await weekDaysProvider.editWorkingHours(context, toOrFrom);
          },
          child: Text(
            text,
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$text:',
                style: TextStyle(
                    fontSize: mq.width * 0.07,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
          Container(
            width: mq.width * 0.3,
            height: mq.height * 0.1,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
              padding: const EdgeInsets.all(15),
              child: const FittedBox(
                child: Icon(
                  Icons.edit,
                  color: Colors.red,
                ),
              ),
            ),
          )
        ],
      );
    }
  }
}
