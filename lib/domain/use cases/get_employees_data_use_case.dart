import '../../core/utilities/dependency_injection.dart';
import '../entities/employee.dart';
import '../repository/base_attendance_repository.dart';

class GetEmployeesDataUseCase {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Stream<List<Employee>> getEmployeesData() {
    return baseAttendanceRepository.getEmployeesData();
  }
}
