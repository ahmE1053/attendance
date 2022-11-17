import 'package:flutter/material.dart';

class EmployeesScreenNoEmployeesWidget extends StatelessWidget {
  const EmployeesScreenNoEmployeesWidget({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(mq.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/not_found.gif',
            fit: BoxFit.fill,
          ),
          FittedBox(
            child: Text(
              'لم يتم اضافة اي موظفين',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: mq.width * 0.08,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeesScreenNoConnectionWidget extends StatelessWidget {
  const EmployeesScreenNoConnectionWidget({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(mq.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/no_connection.png',
            fit: BoxFit.fill,
          ),
          FittedBox(
            child: Text(
              'برجاء التأكد من اتصالاك بالانترنت',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: mq.width * 0.08,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
