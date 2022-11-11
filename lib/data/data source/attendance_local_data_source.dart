import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utilities/dependency_injection.dart';

abstract class BaseLocalDataSource {
  Future<void> changeThemeMode(bool darkMode);

  Future<void> checkForFirstTime();
}

class LocalDataSource extends BaseLocalDataSource {
  @override
  Future<void> checkForFirstTime() async {
    if ((await getIt.getAsync<SharedPreferences>()).containsKey('darkMode')) {
      return;
    } else {
      await getIt.get<SharedPreferences>().setBool(
            'darkMode',
            false,
          );
    }
  }

  @override
  Future<void> changeThemeMode(bool darkMode) async {
    await (await getIt.getAsync<SharedPreferences>()).setBool(
      'darkMode',
      darkMode,
    );
  }
}
