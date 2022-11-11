import '../../core/utilities/dependency_injection.dart';
import '../entities/employee.dart';
import '../repository/base_attendance_repository.dart';

class RemoveEmployeeAbsenceUseCase {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<void> run(
      bool isApologyAccepted, Employee employee, int daysRemoved) async {
    await baseAttendanceRepository.removeEmployeeAbsence(
        isApologyAccepted, employee, daysRemoved);
  }
}
