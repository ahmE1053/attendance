import '../../core/utilities/dependency_injection.dart';
import '../entities/employee.dart';
import '../repository/base_attendance_repository.dart';

class AddNewEmployeeUseCase {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<Employee> addNewEmployeeData(
    String name,
    String start,
    String end,
    List<int> offDays,
    String allowedDelay,
  ) async {
    return baseAttendanceRepository.addNewEmployee(
      name,
      start,
      end,
      offDays,
      allowedDelay,
    );
  }
}
