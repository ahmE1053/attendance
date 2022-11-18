import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data source/attendance_local_data_source.dart';
import '../../data/data source/attendance_remote_datasource.dart';
import '../../data/repository/attendance_repository.dart';
import '../../domain/repository/base_attendance_repository.dart';
import '../../domain/use cases/add_new_employee_use_case.dart';
import '../../domain/use cases/change_theme_use_case.dart';
import '../../domain/use cases/check_theme_first_time_use_case.dart';
import '../../domain/use cases/edit_employee_details_use_case.dart';
import '../../domain/use cases/get_employees_data_use_case.dart';
import '../../domain/use cases/get_qr_code_in_pdf_cloud_use_case.dart';
import '../../domain/use cases/remove_employee_absence_use_case.dart';
import '../../domain/use cases/upload_excel_file_to_storage.dart';

final getIt = GetIt.instance;

Future<void> injection() async {
  getIt.registerLazySingleton<BaseRemoteDatasource>(() => RemoteDataSource());
  getIt.registerLazySingleton<BaseLocalDataSource>(() => LocalDataSource());
  getIt.registerSingletonAsync(() => SharedPreferences.getInstance());

  getIt.registerLazySingleton<BaseAttendanceRepository>(
      () => AttendanceRepository());
  getIt.registerLazySingleton<AddNewEmployeeUseCase>(
      () => AddNewEmployeeUseCase());
  getIt.registerLazySingleton<UploadExcelFileToStorage>(
      () => UploadExcelFileToStorage());
  getIt.registerLazySingleton<UploadExcelFileAllEmployeesToStorage>(
      () => UploadExcelFileAllEmployeesToStorage());
  getIt.registerLazySingleton<GetEmployeesDataUseCase>(
      () => GetEmployeesDataUseCase());
  getIt.registerLazySingleton<RemoveEmployeeAbsenceUseCase>(
      () => RemoveEmployeeAbsenceUseCase());
  getIt.registerLazySingleton<GetQrCodeInPdfUseCaseCloud>(
      () => GetQrCodeInPdfUseCaseCloud());
  getIt.registerLazySingleton<EditEmployeeDetailsUseCase>(
      () => EditEmployeeDetailsUseCase());
  getIt.registerLazySingleton<ChangeThemeModeUseCase>(
      () => ChangeThemeModeUseCase());
  getIt.registerLazySingleton<CheckThemeFirstTimeUseCase>(
      () => CheckThemeFirstTimeUseCase());
}
