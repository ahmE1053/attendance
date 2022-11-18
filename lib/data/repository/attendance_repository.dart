import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/utilities/dependency_injection.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repository/base_attendance_repository.dart';
import '../data source/attendance_local_data_source.dart';
import '../data source/attendance_remote_datasource.dart';

class AttendanceRepository extends BaseAttendanceRepository {
  final BaseRemoteDatasource baseRemoteDatasource =
      getIt.get<BaseRemoteDatasource>();
  final BaseLocalDataSource baseLocalDataSource =
      getIt.get<BaseLocalDataSource>();

  @override
  Future<Employee> addNewEmployee(
    String name,
    String start,
    String end,
    List<int> offDays,
    String allowedDelay,
  ) async {
    return baseRemoteDatasource.addNewEmployee(
      name,
      start,
      end,
      offDays,
      allowedDelay,
    );
  }

  @override
  Stream<List<Employee>> getEmployeesData() {
    return baseRemoteDatasource.getEmployeesData();
  }

  @override
  Future<String> addQrCodePdfToCloudAndGetLink(
      String id, String name, Size mq) async {
    return await baseRemoteDatasource.addQrCodePdfToCloudAndGetLink(
        id, name, mq);
  }

  @override
  Future<void> editEmployeeDetails(
    Employee employee,
    String newName,
    String workingFrom,
    String workingTo,
    List<int> offDays,
    List<DateTime> vacationDays,
    String allowedDelay,
  ) async {
    await baseRemoteDatasource.editEmployeeDetails(
      employee,
      newName,
      workingFrom,
      workingTo,
      offDays,
      vacationDays,
      allowedDelay,
    );
  }

  @override
  Future<void> changeThemeMode(bool darkMode) async {
    await baseLocalDataSource.changeThemeMode(darkMode);
  }

  @override
  Future<void> checkForFirstTime() async {
    await baseLocalDataSource.checkForFirstTime();
  }

  @override
  Future<void> removeEmployeeAbsence(
      bool isApologyAccepted, Employee employee, int daysRemoved) async {
    await baseRemoteDatasource.removeEmployeeAbsence(
        isApologyAccepted, employee, daysRemoved);
  }

  @override
  Future<String> saveExcelFileInCloud(File file, Employee employee) async {
    return await baseRemoteDatasource.saveExcelFileInCloud(file, employee);
  }

  @override
  Future<String> saveExcelFileAllEmployeesInCloud(File file) async {
    return await baseRemoteDatasource.saveExcelFileAllEmployeesInCloud(file);
  }
}
