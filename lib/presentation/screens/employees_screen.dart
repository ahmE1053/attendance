import 'package:attendance/core/providers/app_provider.dart';
import 'package:attendance/core/providers/theme_provider.dart';
import 'package:attendance/core/utilities/dependency_injection.dart';
import 'package:attendance/domain/use%20cases/get_employees_data_use_case.dart';
import 'package:attendance/presentation/screens/add_new_employee_screen.dart';
import 'package:attendance/presentation/screens/apologize_notification_screen.dart';
import 'package:attendance/presentation/screens/employee_details_screen.dart';
import 'package:attendance/presentation/screens/zoom_drawer.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/other/employee_state_color_getter.dart';
import '../../domain/entities/employee.dart';

class GeneralEmployeesScreen extends StatefulWidget {
  static const id = 'GeneralEmployeesScreen';

  const GeneralEmployeesScreen({Key? key}) : super(key: key);

  @override
  State<GeneralEmployeesScreen> createState() => _GeneralEmployeesScreenState();
}

class _GeneralEmployeesScreenState extends State<GeneralEmployeesScreen> {
  late Stream<List<Employee>> employeesStream;

  @override
  void initState() {
    super.initState();
    Provider.of<AppProvider>(context, listen: false).clear();
    employeesStream = getIt.get<GetEmployeesDataUseCase>().getEmployeesData();
  }

  List<Employee> employeesList = [];
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            zoomDrawerController.open!();
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final a = await FirebaseFirestore.instance
                    .collection('employees')
                    .get();
                a.docs.forEach(
                  (element) {
                    FirebaseFirestore.instance
                        .collection('employees')
                        .doc(element.id)
                        .update(
                      {
                        'apologyMessage': 'aws',
                        'isApologizing': true,
                        'isTodayFirstDay': false,
                        'detailedReport': [],
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.add)),
          IconButton(
            onPressed: () async {
              await themeProvider.changeMode();
            },
            icon: themeProvider.darkMode
                ? const Icon(
                    Icons.sunny,
                  )
                : const Icon(
                    Icons.nightlight_round_sharp,
                  ),
          ),
          isLoaded
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApologizeNotificationScreen(
                          employeesList: employeesList
                              .where((element) => element.isApologizing == true)
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: Badge(
                    badgeContent: Text(
                      employeesList
                          .where((element) => element.isApologizing == true)
                          .length
                          .toString(),
                    ),
                    position: BadgePosition.topStart(),
                    showBadge: employeesList
                        .where((element) => element.isApologizing == true)
                        .isNotEmpty,
                    child: const Icon(Icons.email),
                  ),
                )
              : SpinKitDoubleBounce(
                  color: Colors.white,
                ),
        ],
        title: const Text('الموظفين'),
      ),
      body: DefaultTextStyle(
        style: GoogleFonts.cairo(),
        child: StreamBuilder(
          stream: employeesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                  strokeWidth: 10,
                ),
              );
            } else {
              employeesList = snapshot.data!;
              isLoaded = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
              if (employeesList.isEmpty) {
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

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DefaultTextStyle(
                        style: GoogleFonts.cairo(
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
                                    fontSize: mq.width * 0.07,
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
                                    fontSize: mq.width * 0.07,
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
                                    fontSize: mq.width * 0.07,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'الحالة',
                                  style: TextStyle(
                                    fontSize: mq.width * 0.07,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      );
                    } else {
                      final employee = employeesList[index - 1];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeInfoScreen(
                                employee: employee,
                              ),
                            ),
                          );
                        },
                        child: DefaultTextStyle(
                          style: GoogleFonts.cairo(
                            color: Colors.black,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Hero(
                                      tag: employee.id,
                                      child: Material(
                                        type: MaterialType
                                            .transparency, // likely needed
                                        child: Text(
                                          employee.name,
                                          style: TextStyle(
                                            fontSize: mq.width * 0.08,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      employee.lateInMinutes.toString(),
                                      style: TextStyle(
                                        fontSize: mq.width * 0.07,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      employee.absenceDays.toString(),
                                      style: TextStyle(
                                        fontSize: mq.width * 0.07,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: employeeStateColorGetter(
                                        employee.employeeState,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                      child: Text(
                                        employee.employeeState ==
                                                'خارج ساعات العمل'
                                            ? 'خارج ساعات\nالعمل'
                                            : employee.employeeState,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.cairo(
                                          fontSize: mq.width * 0.07,
                                          color:
                                              employee.employeeState == 'غائب'
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: employeesList.length + 1,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
