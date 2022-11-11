import '../../core/utilities/dependency_injection.dart';
import '../entities/employee.dart';
import '../repository/base_attendance_repository.dart';

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
