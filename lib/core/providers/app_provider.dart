import 'package:flutter/material.dart';

import '../../domain/entities/employee.dart';
import '../../presentation/widgets/apologize_notification_screen_widgets/apologize_card.dart';
import '../../presentation/widgets/edit_employee_details_screen_folder/vacation_days_editing_widget.dart';

class AppProvider extends ChangeNotifier {
  var weekDays = {
    'السبت': {
      'value': 6,
      'isSelected': false,
    },
    'الأحد': {
      'value': 7,
      'isSelected': false,
    },
    'الإثنين': {
      'value': 1,
      'isSelected': false,
    },
    'الثلاثاء': {
      'value': 2,
      'isSelected': false,
    },
    'الأربعاء': {
      'value': 3,
      'isSelected': false,
    },
    'الخميس': {
      'value': 4,
      'isSelected': false,
    },
    'الجمعة': {
      'value': 5,
      'isSelected': false,
    },
  };
  String allowedDelayHours = '';
  String allowedDelayMinutes = '';
  List<DateTime> vacationDays = [], absenceDaysList = [];
  bool loading = false, errorState = false, absenceRemoverDone = false;

  TimeOfDay? workingFrom, workingTo;
  String? workingFromString, workingToString;

  void addToAbsenceDaysList(DateTime day) {
    absenceDaysList.add(day);
    notifyListeners();
  }

  void removeFromAbsenceDaysList(DateTime day) {
    absenceDaysList.remove(day);
    notifyListeners();
  }

  void onTap(String day, bool state) {
    weekDays[day]!['isSelected'] = !state;
    notifyListeners();
  }

  void vacationDaysSetter(List<DateTime> vacationDays) {
    final List<DateTime> vacationDaysList = [];
    for (DateTime day in vacationDays) {
      vacationDaysList.add(day);
    }
    this.vacationDays = vacationDaysList;
  }

  String correctWorkingTimesToIso(String workingTime) {
    final workingTimeList = workingTime.split(':');
    if (workingTimeList[0] == '0') {
      workingTimeList[0] = '00';
    }
    if (workingTimeList[1] == '0') {
      workingTimeList[1] = '00';
    }
    if (int.parse(workingTimeList[0]) < 10 &&
        int.parse(workingTimeList[1]) < 10) {
      if (!workingTimeList[0].startsWith('0')) {
        workingTimeList[0] = '0${workingTimeList[0]}';
      }
      if (!workingTimeList[1].startsWith('0')) {
        workingTimeList[1] = '0${workingTimeList[1]}';
      }
      return '${workingTimeList[0]}:${workingTimeList[1]}';
    } else if (int.parse(workingTimeList[0]) < 10 &&
        int.parse(workingTimeList[1]) >= 10) {
      if (!workingTimeList[0].startsWith('0')) {
        workingTimeList[0] = '0${workingTimeList[0]}';
      }
      return '${workingTimeList[0]}:${workingTimeList[1]}';
    } else if (int.parse(workingTimeList[0]) >= 10 &&
        int.parse(workingTimeList[1]) < 10) {
      if (!workingTimeList[1].startsWith('0')) {
        workingTimeList[1] = '0${workingTimeList[1]}';
      }
      return '${workingTimeList[0]}:${workingTimeList[1]}';
    }
    return '${workingTimeList[0]}:${workingTimeList[1]}';
  }

  bool checkIFAllowedDelayTimeIsZero() {
    if ((allowedDelayMinutes == '' || allowedDelayMinutes == '0') &&
        (allowedDelayHours == '' || allowedDelayHours == '0')) {
      return true;
    }
    return false;
  }

  String getAllowedDelay() {
    if (allowedDelayHours == '') {
      allowedDelayHours = '00';
    }
    if (allowedDelayMinutes == '') {
      allowedDelayMinutes = '00';
    }
    if (int.parse(allowedDelayHours) < 10 &&
        int.parse(allowedDelayMinutes) < 10) {
      if (!allowedDelayHours.startsWith('0')) {
        allowedDelayHours = '0$allowedDelayHours';
      }
      if (!allowedDelayMinutes.startsWith('0')) {
        allowedDelayMinutes = '0$allowedDelayMinutes';
      }
      return '$allowedDelayHours:$allowedDelayMinutes';
    } else if (int.parse(allowedDelayHours) < 10 &&
        int.parse(allowedDelayMinutes) >= 10) {
      if (!allowedDelayHours.startsWith('0')) {
        allowedDelayHours = '0$allowedDelayHours';
      }
      return '$allowedDelayHours:$allowedDelayMinutes';
    } else if (int.parse(allowedDelayHours) >= 10 &&
        int.parse(allowedDelayMinutes) < 10) {
      if (!allowedDelayMinutes.startsWith('0')) {
        allowedDelayMinutes = '0$allowedDelayMinutes';
      }
      return '$allowedDelayHours:$allowedDelayMinutes';
    }
    return '$allowedDelayHours:$allowedDelayMinutes';
  }

  void allowedDelayParser(String allowedDelay) {
    final allowedDelayList = allowedDelay.split(':');
    allowedDelayHours = allowedDelayList[0];
    allowedDelayMinutes = allowedDelayList[1];
  }

  void deleteDayFromVacationDays(
      DateTime day,
      GlobalKey<SliverAnimatedListState> globalKey,
      double fontSize,
      String text) {
    globalKey.currentState!.removeItem(
      vacationDays.indexOf(day),
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: VacationDaysEditingWidget(
            vacationDay: day,
            fontSize: fontSize,
            formattedDayInArabic: text,
          ),
        );
      },
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    vacationDays.remove(day);
  }

  void deleteApologyMessage(
    Employee employee,
    int index,
    GlobalKey<AnimatedListState> listKey,
  ) {
    listKey.currentState!.removeItem(
      duration: const Duration(milliseconds: 500),
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: ApologizeNotificationCard(
          employee: employee,
          expanded: true,
        ),
      ),
    );
  }

  List<int> offDaysGetter() {
    return weekDays.entries
        .where((element) => element.value['isSelected'] == true)
        .map((e) => e.value['value'] as int)
        .toList();
  }

  void addToVacationDays(
    DateTime dateTime,
    GlobalKey<SliverAnimatedListState> globalKey,
  ) {
    int index =
        vacationDays.indexWhere((element) => dateTime.isBefore(element));
    index == -1 ? index = vacationDays.length : null;
    vacationDays.insert(
      index,
      dateTime,
    );
    globalKey.currentState!.insertItem(
      index,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    notifyListeners();
  }

  void changeErrorState(bool state) {
    errorState = state;
    notifyListeners();
  }

  bool checkNull() {
    if (workingTo == null || workingFrom == null) {
      return true;
    } else {
      return false;
    }
  }

  void clear() {
    workingTo = null;
    workingFrom = null;
    for (var mapEntry in weekDays.entries) {
      mapEntry.value['isSelected'] = false;
    }
    errorState = false;
    allowedDelayMinutes = '';
    allowedDelayHours = '';
    vacationDays.clear();
  }

  void editWeekDays(List<int> offDaysList) {
    for (int offDay in offDaysList) {
      final day = weekDays.entries.where(
        (element) {
          return element.value['value'] == offDay;
        },
      );
      for (var element in day) {
        element.value['isSelected'] = true;
      }
    }
  }

  Future<void> editWorkingHours(BuildContext context, bool toOrFrom) async {
    if (!toOrFrom) {
      workingFrom = await showTimePicker(
            context: context,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
              ),
              child: child!,
            ),
            initialTime: workingFrom ?? TimeOfDay.now(),
          ) ??
          workingFrom;
    } else {
      workingTo = await showTimePicker(
            context: context,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
              ),
              child: child!,
            ),
            initialTime: workingTo ?? TimeOfDay.now(),
          ) ??
          workingTo;
    }
    notifyListeners();
  }

  String getCorrectTimeText(TimeOfDay timeOfDay) {
    return '${timeOfDay.hourOfPeriod}:${timeOfDay.minute}${timeOfDay.period == DayPeriod.am ? " ص" : " م"}';
  }

  void changeLoading(bool state) {
    loading = state;
    notifyListeners();
  }
}
