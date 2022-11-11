import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.workingFrom,
    required super.apologyMessage,
    required super.workingTo,
    required super.offDays,
    required super.name,
    required super.lateInMinutes,
    required super.absenceDays,
    required super.detailedReport,
    required super.employeeState,
    required super.employeeQrCodePdfLink,
    required super.id,
    required super.currentDayWorkingFrom,
    required super.currentDayWorkingTo,
    required super.vacationDays,
    required super.allowedDelay,
    required super.isApologizing,
    required super.downloadUrl,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final format = DateFormat('HH:mm');

    final currentDayWorkingFrom = json['currentDayWorkingFrom'];
    final currentDayWorkingTo = json['currentDayWorkingTo'];
    final List<String> vacationDaysString =
        List<String>.from(json['vacationDays'] ?? []);
    final List<DateTime> vacationDays =
        vacationDaysString.map((e) => DateTime.parse(e)).toList();
    return EmployeeModel(
      currentDayWorkingFrom: currentDayWorkingFrom == null
          ? null
          : TimeOfDay.fromDateTime(format.parse(currentDayWorkingFrom)),
      currentDayWorkingTo: currentDayWorkingTo == null
          ? null
          : TimeOfDay.fromDateTime(format.parse(currentDayWorkingTo)),
      vacationDays: vacationDays,
      id: json['id'] ?? '',
      employeeQrCodePdfLink: json['employeeQrCodeImageLink'] ?? '',
      employeeState: json['employeeState'],
      offDays: List<int>.from(json['offDays']),
      name: json['name'],
      lateInMinutes: json['lateInMinutes'],
      absenceDays: json['absenceDays'],
      detailedReport: List.from(json['detailedReport']),
      workingFrom: TimeOfDay.fromDateTime(format.parse(json['workingFrom'])),
      workingTo: TimeOfDay.fromDateTime(format.parse(json['workingTo'])),
      allowedDelay: json['allowedDelay'] ?? '0:0',
      apologyMessage: json['apologyMessage'] ?? '',
      isApologizing: json['isApologizing'] ?? false,
      downloadUrl: json['employeeQrCodePdfLink'],
    );
  }
}
