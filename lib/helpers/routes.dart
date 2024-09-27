import 'package:get/get.dart';

import '../controllers/dooring/dooring_controller.dart';
import '../controllers/dooring/kapal_controller.dart';
import '../screens/dooring/dooring.dart';
import '../screens/login.dart';
import '../screens/master data/kapal.dart';
import '../screens/master data/type_motor.dart';
import '../screens/master data/wilayah.dart';
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
        GetPage(
            name: '/data-dooring',
            page: () => const Dooring(),
            binding: BindingsBuilder(() {
              Get.put(DooringController());
            })),
        // master data
        GetPage(
            name: '/master-kapal',
            page: () => const MasterKapal(),
            binding: BindingsBuilder(() {
              Get.put(KapalController());
            })),
        GetPage(
            name: '/master-wilayah',
            page: () => const MasterWilayah(),
            binding: BindingsBuilder(() {
              Get.put(WilayahController());
            })),
        GetPage(
            name: '/master-motor',
            page: () => const MasterTypeMotor(),
            binding: BindingsBuilder(() {
              Get.put(TypeMotorController());
            })),
      ];
}
