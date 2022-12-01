import 'dart:io';

import 'package:flutter/material.dart';

import '../entities/employee.dart';

abstract class BaseAttendanceRepository {
  Stream<List<Employee>> getEmployeesData();

  Future<String> saveExcelFileAllEmployeesInCloud(File file);

  Future<Employee> addNewEmployee(
    String name,
    String start,
    String end,
    List<int> offDays,
    String allowedDelay,
  );

  Future<String> addQrCodePdfToCloudAndGetLink(String id, String name, Size mq);

  Future<void> editEmployeeDetails(
    Employee employee,
    String newName,
    String workingFrom,
    String workingTo,
    List<int> offDays,
    List<DateTime> vacationDays,
    String allowedDelay,
  );

  Future<void> changeThemeMode(bool darkMode);

  Future<void> checkForFirstTime();

  Future<void> removeEmployeeAbsence(
      bool isApologyAccepted, Employee employee, int daysRemoved);

  Future<String> saveExcelFileInCloud(File file, Employee employee);

  Future<void> deleteEmployee(Employee employee);
}
