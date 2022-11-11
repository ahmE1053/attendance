import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/providers/app_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/utilities/dependency_injection.dart';
import 'presentation/screens/add_new_employee_screen.dart';
import 'presentation/screens/zoom_drawer.dart';
import 'presentation/screens/employees_screen.dart';
import 'domain/use cases/check_theme_first_time_use_case.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.getToken().then((value) {
    FirebaseFirestore.instance
        .collection('fcmTokens')
        .doc(value)
        .set({'token': value});
  });
  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  await injection();
  await getIt.get<CheckThemeFirstTimeUseCase>().run();
  runApp(const ProviderLayer());
}

class ProviderLayer extends StatelessWidget {
  const ProviderLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => AppProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ThemeProvider()),
      ],
      child: const MyApp(),
    );
  }
}

//TODO handle upload file to storage logic
//TODO add outside working hours when adding a new employee
//TODO if absence days are more than 1 give the option to remove 1 or how many days

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData.from(
        textTheme: GoogleFonts.cairoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purpleAccent,
          brightness: themeProvider.getTheme(),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
      ],
      initialRoute: ZoomDrawerScreen.id,
      routes: {
        ZoomDrawerScreen.id: (context) => const ZoomDrawerScreen(),
        AddNewEmployee.id: (context) => const AddNewEmployee(),
        GeneralEmployeesScreen.id: (context) => const GeneralEmployeesScreen(),
      },
    );
  }
}
