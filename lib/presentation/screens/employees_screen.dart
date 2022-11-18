import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import '../../core/providers/network_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/utilities/dependency_injection.dart';
import '../../domain/entities/employee.dart';
import '../../domain/use cases/get_employees_data_use_case.dart';
import '../widgets/employees_screen_widgets/exports.dart';
import '../widgets/no_connection_bottom_bar.dart';

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
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;
    final mq = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: EmployeesScreenAppBar(
          themeProvider: themeProvider,
          isLoaded: isLoaded,
          isConnectionWorking: isConnectionWorking,
          employeesList: employeesList),
      bottomNavigationBar: NoConnectionBottomBar(
        isConnectionWorking ? 0 : mq.height * 0.07,
      ),
      body: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'Cairo'),
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
                if (!isConnectionWorking) {
                  //shows if no connection and first time
                  //otherwise firestore saves the data on the phone's storage
                  return EmployeesScreenNoConnectionWidget(mq: mq);
                }
                return EmployeesScreenNoEmployeesWidget(mq: mq);
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
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.portrait) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return EmployeesScreenTableHeaderWidget(mq: mq);
                          } else {
                            final employee = employeesList[index - 1];
                            return EmployeesScreenTableEntryWidget(
                                employee: employee, mq: mq);
                          }
                        },
                        itemCount: employeesList.length + 1,
                      );
                    } else {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SizedBox(
                              height: mq.height * 0.15,
                              child: EmployeesScreenTableHeaderWidget(
                                mq: mq,
                              ),
                            );
                          } else {
                            final employee = employeesList[index - 1];
                            return SizedBox(
                              height: mq.height * 0.3,
                              child: EmployeesScreenTableEntryWidget(
                                  employee: employee, mq: mq),
                            );
                          }
                        },
                        itemCount: employeesList.length + 1,
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
