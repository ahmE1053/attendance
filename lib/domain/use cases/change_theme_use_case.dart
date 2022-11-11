import '../../core/utilities/dependency_injection.dart';
import '../repository/base_attendance_repository.dart';

class ChangeThemeModeUseCase {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();

  Future<void> run(bool darkMode) async {
    await baseAttendanceRepository.changeThemeMode(darkMode);
  }
}
