import 'package:dooring/screens/laporan/defect.dart';
import 'package:get/get.dart';

import '../controllers/dooring/dooring_controller.dart';
import '../controllers/dooring/jadwal_kapal_controller.dart';
import '../controllers/dooring/kapal_controller.dart';
import '../screens/dooring/jadwal_kapal.dart';
// import '../screens/dooring/jadwal_kapal_acc.dart';
import '../screens/laporan/total_unit.dart';
import '../screens/dooring/dooring.dart';
import '../screens/profile.dart';
import '../screens/semua data/jadwal_semua_kapal.dart';
import '../screens/semua data/semua_dooring.dart';
import '../screens/login.dart';
import '../screens/master data/kapal.dart';
import '../screens/master data/part_motor.dart';
import '../screens/master data/pelayaran.dart';
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
          name: '/profile',
          page: () => const Profile(),
        ),
        GetPage(
            name: '/data-dooring',
            page: () => const Dooring(),
            binding: BindingsBuilder(() {
              Get.put(DooringController());
            })),
        GetPage(
            name: '/jadwal-kapal',
            page: () => const JadwalKapal(),
            binding: BindingsBuilder(() {
              Get.put(JadwalKapalController());
            })),
        // GetPage(
        //     name: '/jadwal-kapal-acc',
        //     page: () => const JadwalKapalAcc(),
        //     binding: BindingsBuilder(() {
        //       Get.put(JadwalKapalController());
        //     })),
        // master data
        GetPage(
            name: '/master-kapal',
            page: () => const MasterKapal(),
            binding: BindingsBuilder(() {
              Get.put(KapalController());
            })),
        GetPage(
            name: '/master-pelayaran',
            page: () => const MasterPelayaran(),
            binding: BindingsBuilder(() {
              Get.put(PelayaranController());
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
        GetPage(
            name: '/master-part',
            page: () => const PartMotor(),
            binding: BindingsBuilder(() {
              Get.put(PartMotorController());
            })),

        // Semua Data
        GetPage(
            name: '/semua-jadwal-kapal',
            page: () => const JadwalSemuaKapal(),
            binding: BindingsBuilder(() {
              Get.put(JadwalKapalController());
            })),
        GetPage(
            name: '/semua-dooring',
            page: () => const SemuaDooring(),
            binding: BindingsBuilder(() {
              Get.put(DooringController());
            })),
        // Laporan
        GetPage(
          name: '/laporan-total-unit',
          page: () => const TotalUnit(),
        ),
        GetPage(
          name: '/laporan-defect',
          page: () => const LaporanDefect(),
        ),
      ];
}
