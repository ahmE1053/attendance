import 'dart:io';

import '../../core/utilities/dependency_injection.dart';
import '../entities/employee.dart';
import '../repository/base_attendance_repository.dart';

class UploadExcelFileToStorage {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<String> run(File file, Employee employee) async {
    return await baseAttendanceRepository.saveExcelFileInCloud(file, employee);
  }
}

class UploadExcelFileAllEmployeesToStorage {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<String> run(File file) async {
    return await baseAttendanceRepository
        .saveExcelFileAllEmployeesInCloud(file);
  }
}
