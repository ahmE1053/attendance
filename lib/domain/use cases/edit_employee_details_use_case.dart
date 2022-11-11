import 'package:attendance/core/utilities/dependency_injection.dart';
import 'package:attendance/data/repository/attendance_repository.dart';
import 'package:attendance/domain/repository/base_attendance_repository.dart';
import 'package:flutter/material.dart';

import '../entities/employee.dart';

class EditEmployeeDetailsUseCase {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<void> editEmployeeDetails(
    Employee employee,
    String newName,
    String workingFrom,
    String workingTo,
    List<int> offDays,
    List<DateTime> vacationDays,
    String allowedDelay,
  ) async {
    await baseAttendanceRepository.editEmployeeDetails(
      employee,
      newName,
      workingFrom,
      workingTo,
      offDays,
      vacationDays,
      allowedDelay,
    );
  }
}
