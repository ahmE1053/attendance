import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../../domain/entities/employee.dart';
import '../widgets/apologize_notification_screen_widgets/apologize_card.dart';

class ApologizeNotificationScreen extends StatefulWidget {
  final List<Employee> employeesList;

  const ApologizeNotificationScreen({Key? key, required this.employeesList})
      : super(key: key);

  @override
  State<ApologizeNotificationScreen> createState() =>
      _ApologizeNotificationScreenState();
}

class _ApologizeNotificationScreenState
    extends State<ApologizeNotificationScreen> {
  @override
  void initState() {
    super.initState();
    employeesList = widget.employeesList;
  }

  late List<Employee> employeesList;
  final listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final mq = MediaQuery.of(context).size;
    final employeesList = widget.employeesList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاعتذارات'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(mq.width * 0.03),
          child: AnimatedList(
            key: listKey,
            initialItemCount: employeesList.length,
            itemBuilder: (context, index, _) {
              final employee = employeesList[index];
              return ApologizeNotificationCard(
                appProvider: appProvider,
                expanded: false,
                employee: employee,
                function: () {
                  employeesList.remove(employee);
                  appProvider.deleteApologyMessage(
                    employee,
                    index,
                    listKey,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
