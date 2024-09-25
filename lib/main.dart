import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'helpers/connectivity.dart';
import 'helpers/routes.dart';
import 'screens/login.dart';
import 'screens/onboarding.dart';
import 'screens/rootpage.dart';
import 'utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final localStorage = GetStorage();
  final bool isFirstTime = localStorage.read('IsFirstTime') ?? true;
  final bool isLoggedIn = localStorage.read('user') != null;

  Widget initialPage;

  if (isFirstTime) {
    localStorage.write('IsFirstTime', false);
    initialPage = const OnboardingScreen();
  } else {
    initialPage = isLoggedIn ? const Rootpage() : const LoginScreen();
  }

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
      home: const OnboardingScreen(),
      // home: initialPage,
      getPages: AppRoutes.routes(),
      initialBinding: InitialBindings(),
    );
  }
}
