import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../core/providers/app_provider.dart';
import '../../core/utilities/dependency_injection.dart';
import '../../domain/entities/employee.dart';
import '../../domain/use cases/remove_employe_absence_use_case.dart';

class ApologizeNotificationScreen extends StatefulWidget {
  final List<Employee> employeesList;

  const ApologizeNotificationScreen({Key? key, required this.employeesList})
      : super(key: key);

  @override
  State<ApologizeNotificationScreen> createState() =>
      _ApologizeNotificationScreenState();
}

class _ApologizeNotificationScreenState
    extends State<ApologizeNotificationScreen>
    with SingleTickerProviderStateMixin {
  final roundedLoadingButtonController = RoundedLoadingButtonController(),
      roundedLoadingButtonController2 = RoundedLoadingButtonController();

  @override
  void initState() {
    //
    super.initState();
    employeesList = widget.employeesList;
  }

  late List<Employee> employeesList;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final mq = MediaQuery.of(context).size;
    final employeesList = widget.employeesList;
    final _listKey = GlobalKey<AnimatedListState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاعتذارات'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(mq.width * 0.03),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: employeesList.length,
            itemBuilder: (context, index, _) {
              final employee = employeesList[index];
              return PeaceMaker(
                expanded: false,
                employee: employee,
                roundedLoadingButtonController: roundedLoadingButtonController,
                roundedLoadingButtonController2:
                    roundedLoadingButtonController2,
                function: () {
                  employeesList.remove(employee);
                  appProvider.deleteApologyMessage(
                    employee,
                    index,
                    roundedLoadingButtonController,
                    roundedLoadingButtonController2,
                    _listKey,
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

class PeaceMaker extends StatelessWidget {
  const PeaceMaker({
    Key? key,
    required this.employee,
    required this.roundedLoadingButtonController,
    required this.roundedLoadingButtonController2,
    this.function,
    required this.expanded,
  }) : super(key: key);
  final Employee employee;
  final RoundedLoadingButtonController roundedLoadingButtonController,
      roundedLoadingButtonController2;
  final void Function()? function;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      key: ValueKey(employee.id),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
      ),
      margin: EdgeInsets.symmetric(
        vertical: mq.height * 0.015,
        horizontal: mq.width * 0.01,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(
          vertical: mq.height * 0.02,
          horizontal: mq.width * 0.02,
        ),
        initiallyExpanded: expanded,
        childrenPadding: EdgeInsets.only(
          bottom: mq.height * 0.02,
          left: mq.width * 0.02,
          right: mq.width * 0.02,
        ),
        title: Text(
          employee.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: mq.width * 0.07,
          ),
        ),
        children: [
          Text(
            employee.apologyMessage,
            style: TextStyle(
              fontSize: mq.width * 0.05,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: mq.width * 0.35,
                child: RoundedLoadingButton(
                  successColor: Colors.green,
                  controller: roundedLoadingButtonController,
                  onPressed: () async {
                    roundedLoadingButtonController.start();
                    await getIt
                        .get<RemoveEmployeeAbsenceUseCase>()
                        .run(true, employee);
                    roundedLoadingButtonController.success();
                    (function ?? () {}).call();
                  },
                  color: Colors.greenAccent,
                  child: const Text(
                    'قبول',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: mq.width * 0.35,
                child: RoundedLoadingButton(
                  controller: roundedLoadingButtonController2,
                  successColor: Colors.green,
                  onPressed: () async {
                    roundedLoadingButtonController2.start();
                    await getIt
                        .get<RemoveEmployeeAbsenceUseCase>()
                        .run(false, employee);
                    roundedLoadingButtonController2.success();
                    (function ?? () {}).call();
                  },
                  color: Colors.redAccent,
                  child: const Text(
                    'رفض',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
