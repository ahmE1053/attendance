import 'package:flutter/material.dart';

class VacationDaysEditingWidget extends StatelessWidget {
  const VacationDaysEditingWidget({
    Key? key,
    required this.vacationDay,
    required this.fontSize,
    required this.formattedDayInArabic,
    this.onTapFunction,
  }) : super(key: key);
  final double fontSize;
  final DateTime vacationDay;
  final String formattedDayInArabic;
  final void Function()? onTapFunction;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      margin: EdgeInsets.symmetric(vertical: mq.height * 0.01),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 10,
            child: FittedBox(
              alignment: Alignment.centerRight,
              fit: BoxFit.scaleDown,
              child: Text(
                'يوم $formattedDayInArabic',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: FittedBox(
                  child: GestureDetector(
                    onTap: onTapFunction,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      // radius: mq.width * 0.04,
                      child: const Icon(
                        Icons.delete,
                        // size: mq.width * 0.04,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
