import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'add_new_employee_screen.dart';
import 'employees_screen.dart';

final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

class ZoomDrawerScreen extends StatelessWidget {
  static const id = 'ZoomDrawerScreen';

  const ZoomDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return ZoomDrawer(
      controller: zoomDrawerController,
      isRtl: true,
      angle: 0,
      menuBackgroundColor: const Color(0xffE3A6ED),
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
            onTap: () {
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
                  padding: EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.add,
                      size: mq.width * 0.08,
                      color: const Color(0xffE3A6ED),
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
