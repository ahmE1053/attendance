import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import '../../core/providers/network_provider.dart';
import '../../other/network_problem_notifier.dart';
import 'add_new_employee_screen.dart';
import 'employees_screen.dart';

final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

class ZoomDrawerScreen extends StatelessWidget {
  static const id = 'ZoomDrawerScreen';

  const ZoomDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;
    final mq = MediaQuery.of(context).size;
    return ZoomDrawer(
      controller: zoomDrawerController,
      isRtl: true,
      angle: 0,
      menuBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
      slideWidth: mq.width * 0.3,
      mainScreenScale: 0.1,
      mainScreenTapClose: true,
      menuScreenWidth: mq.width * 0.35,
      showShadow: true,
      style: DrawerStyle.style2,
      menuScreen: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: !isConnectionWorking
                ? () {
                    networkProblemNotifier(context);
                    zoomDrawerController.close!();
                  }
                : () {
                    Navigator.pushNamed(
                      context,
                      AddNewEmployee.id,
                    );
                    zoomDrawerController.close!();
                  },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.add,
                      size: mq.width * 0.08,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.03,
                ),
                const FittedBox(
                  child: Text(
                    'اضافة موظف جديد',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      mainScreen: const GeneralEmployeesScreen(),
    );
  }
}
