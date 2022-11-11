import 'package:attendance/core/utilities/dependency_injection.dart';
import 'package:attendance/domain/repository/base_attendance_repository.dart';

import '../entities/employee.dart';

class RemoveEmployeeAbsenceUseCase {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<void> run(
      bool isApologyAccepted, Employee employee, int daysRemoved) async {
    await baseAttendanceRepository.removeEmployeeAbsence(
        isApologyAccepted, employee, daysRemoved);
  }
}
