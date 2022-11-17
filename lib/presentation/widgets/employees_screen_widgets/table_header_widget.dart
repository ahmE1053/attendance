import 'package:flutter/material.dart';

class EmployeesScreenTableHeaderWidget extends StatelessWidget {
  const EmployeesScreenTableHeaderWidget({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: 'Cairo',
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'الاسم',
                style: TextStyle(
                  fontSize: mq.width * 0.06,
                ),
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'التأخر ',
                style: TextStyle(
                  fontSize: mq.width * 0.06,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'الغياب',
                style: TextStyle(
                  fontSize: mq.width * 0.06,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'الحالة',
                style: TextStyle(
                  fontSize: mq.width * 0.06,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
