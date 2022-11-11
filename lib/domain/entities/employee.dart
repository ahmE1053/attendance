import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Employee extends Equatable {
  final String name,
      employeeState,
      employeeQrCodePdfLink,
      id,
      allowedDelay,
      apologyMessage,
      downloadUrl;

  final TimeOfDay workingFrom, workingTo;
  final TimeOfDay? currentDayWorkingFrom, currentDayWorkingTo;

  final bool isApologizing;

  final int lateInMinutes, absenceDays;
  final List<DateTime> vacationDays;
  final List<int> offDays;
  final List<Map<String, dynamic>> detailedReport;

  const Employee({
    required this.vacationDays,
    required this.currentDayWorkingFrom,
    required this.currentDayWorkingTo,
    required this.id,
    required this.workingFrom,
    required this.workingTo,
    required this.offDays,
    required this.name,
    required this.lateInMinutes,
    required this.absenceDays,
    required this.detailedReport,
    required this.employeeState,
    required this.employeeQrCodePdfLink,
    required this.allowedDelay,
    required this.apologyMessage,
    required this.isApologizing,
    required this.downloadUrl,
  });

  @override
  List<Object?> get props => [
        name,
        currentDayWorkingFrom,
        currentDayWorkingTo,
        lateInMinutes,
        absenceDays,
        vacationDays,
        detailedReport,
        offDays,
        employeeState,
        id,
        workingTo,
        workingFrom,
        employeeQrCodePdfLink,
        allowedDelay,
        apologyMessage,
        isApologizing,
        downloadUrl,
      ];
}
