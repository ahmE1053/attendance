import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../../core/providers/network_provider.dart';
import '../../domain/entities/employee.dart';
import '../widgets/apologize_notification_screen_widgets/apologize_card.dart';
import '../widgets/no_connection_bottom_bar.dart';

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
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;

    final mq = MediaQuery.of(context).size;
    final employeesList = widget.employeesList;
    return Scaffold(
      bottomNavigationBar: NoConnectionBottomBar(
        isConnectionWorking ? 0 : mq.height * 0.07,
      ),
      appBar: AppBar(
        title: const Text('الاعتذارات'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(mq.width * 0.03),
          child: employeesList.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(mq.width * 0.05),
                    child: Text(
                      'لا يوجد اعتذارات مقدمة',
                      style: TextStyle(
                        fontSize: mq.width * 0.08,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                )
              : AnimatedList(
                  key: listKey,
                  initialItemCount: employeesList.length,
                  itemBuilder: (context, index, _) {
                    final employee = employeesList[index];
                    return ApologizeNotificationCard(
                      isConnectionWorking: isConnectionWorking,
                      appProvider: appProvider,
                      expanded: false,
                      employee: employee,
                      function: () async {
                        employeesList.remove(employee);
                        await appProvider.deleteApologyMessage(
                          employee,
                          index,
                          listKey,
                          isConnectionWorking,
                        );
                        setState(() {});
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
