import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../core/providers/app_provider.dart';
import '../../../domain/use cases/add_new_employee_use_case.dart';
import '../../screens/qr_code_screen.dart';

class AddNewEmployeeButton extends StatelessWidget {
  const AddNewEmployeeButton({
    required this.mq,
    Key? key,
    required this.formKey,
    required this.appProvider,
    required this.textEditingController,
    required this.isConnectionWorking,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final AppProvider appProvider;
  final TextEditingController textEditingController;
  final bool isConnectionWorking;

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 3,
          ),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(),
        onPressed: !isConnectionWorking
            ? null
            : () async {
                final theme = Theme.of(context).colorScheme;
                if (!formKey.currentState!.validate()) {
                  return;
                }
                if (appProvider.checkNull()) {
                  if (!appProvider.errorState) {
                    appProvider.changeErrorState(true);
                  }
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('برجاء اختيار مواعيد حضور وانصراف الموظف'),
                      margin: EdgeInsets.only(
                        bottom: mq.height * 0.08,
                        right: 20,
                        left: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                final List<int> offDays =
                    List<int>.from(appProvider.offDaysGetter());
                final navigator = Navigator.of(context);

                if (appProvider.offDaysGetter().isEmpty) {
                  bool noVacationAccepted = false;
                  await Alert(
                    context: context,
                    title: 'تحذير',
                    desc: 'هل انت متأكد من عدم اعطاء الموظف اي اجازات',
                    type: AlertType.warning,
                    style: AlertStyle(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      titleStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      descStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    closeIcon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    buttons: [
                      DialogButton(
                        color: Theme.of(context).colorScheme.primary,
                        child: Text(
                          'نعم',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          noVacationAccepted = true;
                          Navigator.pop(context);
                        },
                      ),
                      DialogButton(
                        color: Theme.of(context).colorScheme.primary,
                        child: Text(
                          'لا',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ).show();
                  if (!noVacationAccepted) {
                    return;
                  }
                }
                if (appProvider.checkIFAllowedDelayTimeIsZero()) {
                  bool noAllowedDelayAccepted = false;
                  await Alert(
                    context: context,
                    title: 'تحذير',
                    desc:
                        'هل انت متأكد من عدم اعطاء الموظف اي وقت مسموح للتأخير',
                    type: AlertType.warning,
                    style: AlertStyle(
                      backgroundColor: theme.background,
                      titleStyle: TextStyle(
                        color: theme.onBackground,
                      ),
                      descStyle: TextStyle(
                        color: theme.onBackground,
                      ),
                    ),
                    closeIcon: Icon(
                      Icons.close,
                      color: theme.onBackground,
                    ),
                    buttons: [
                      DialogButton(
                        color: theme.primary,
                        child: Text(
                          'نعم',
                          style: TextStyle(
                            color: theme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          noAllowedDelayAccepted = true;
                          Navigator.pop(context);
                        },
                      ),
                      DialogButton(
                        color: theme.primary,
                        child: Text(
                          'لا',
                          style: TextStyle(
                            color: theme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ).show();
                  if (!noAllowedDelayAccepted) {
                    return;
                  }
                }
                appProvider.changeLoading(true);

                appProvider.workingFromString =
                    appProvider.correctWorkingTimesToIso(
                        '${appProvider.workingFrom!.hour}:${appProvider.workingFrom!.minute}');
                appProvider.workingToString = appProvider.correctWorkingTimesToIso(
                    '${appProvider.workingTo!.hour}:${appProvider.workingTo!.minute}');
                final employeeData =
                    await AddNewEmployeeUseCase().addNewEmployeeData(
                  textEditingController.value.text,
                  appProvider.workingFromString!,
                  appProvider.workingToString!,
                  offDays,
                  appProvider.getAllowedDelay(),
                );
                appProvider.changeLoading(false);
                appProvider.clear();
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => QrCodeScreen(
                      name: employeeData.name,
                      id: employeeData.id,
                      firstTime: true,
                      downloadUrl: employeeData.downloadUrl,
                    ),
                  ),
                );
              },
        child: appProvider.loading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text('تسجيل الموظف'),
      ),
    );
  }
}
