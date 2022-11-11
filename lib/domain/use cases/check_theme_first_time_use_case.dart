import '../../core/utilities/dependency_injection.dart';
import '../../data/data source/attendance_local_data_source.dart';

class CheckThemeFirstTimeUseCase {
  final BaseLocalDataSource baseLocalDataSource =
      getIt.get<BaseLocalDataSource>();
  Future<void> run() async {
    await baseLocalDataSource.checkForFirstTime();
  }
}
