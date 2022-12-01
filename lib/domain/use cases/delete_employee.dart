import '../../core/utilities/dependency_injection.dart';
import '../entities/employee.dart';
import '../repository/base_attendance_repository.dart';

class DeleteEmployeeUseCase {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<void> run(Employee employee) async {
    await baseAttendanceRepository.deleteEmployee(employee);
  }
}
