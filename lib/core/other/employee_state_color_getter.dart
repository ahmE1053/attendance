import 'package:flutter/material.dart';

Color employeeStateColorGetter(String employeeState) {
  if (employeeState == 'حاضر' || employeeState == 'أجازة اليوم') {
    return Colors.greenAccent;
  } else if (employeeState == 'خارج ساعات العمل') {
    return Colors.transparent;
  } else {
    return Colors.red;
  }
}
