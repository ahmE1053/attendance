import 'package:attendance/core/providers/network_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  final binding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.getToken().then(
    (value) {
      FirebaseFirestore.instance
          .collection('fcmTokens')
          .doc(value)
          .set({'token': value});
    },
  );
  binding.addPostFrameCallback(
    (_) async {
      BuildContext? context = binding.renderViewElement;
      if (context != null) {
        precacheImage(const AssetImage('assets/no_connection.png'), context);
        precacheImage(const AssetImage('assets/not_found.gif'), context);
      }
    },
  );
  await injection();
  await getIt.get<CheckThemeFirstTimeUseCase>().run();
  // GoogleFonts.config.allowRuntimeFetching = false;

  runApp(
    DevicePreview(
        enabled: true,
        builder: (context) => const ProviderLayer() // Wrap your app
        ),
  );
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
        ChangeNotifierProvider(
            create: (BuildContext context) => NetworkProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NetworkProvider>(context, listen: false)
        .changeIsConnectionWorking();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        fontFamily: 'cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
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
