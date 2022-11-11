import 'package:attendance/core/utilities/dependency_injection.dart';
import 'package:attendance/data/data%20source/attendance_local_data_source.dart';

class CheckThemeFirstTimeUseCase {
  final BaseLocalDataSource baseLocalDataSource =
      getIt.get<BaseLocalDataSource>();
  Future<void> run() async {
    await baseLocalDataSource.checkForFirstTime();
  }
}
