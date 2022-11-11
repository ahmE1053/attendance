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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        trailing: GestureDetector(
          onTap: onTapFunction,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(
              Icons.delete,
            ),
          ),
        ),
        title: Text(
          'يوم $formattedDayInArabic',
          style: TextStyle(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
