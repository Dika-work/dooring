import 'package:get/get.dart';

import '../screens/login.dart';
import '../screens/onboarding.dart';
import '../screens/rootpage.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: '/',
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/rootpage',
          page: () => const Rootpage(),
        ),
      ];
}
