import 'package:dooring/models/user_model.dart';
import 'package:get/get.dart';

import '../../models/dooring/jadwal_kapal_acc_model.dart';
import '../../repository/dooring/jadwal_kapal_acc_repo.dart';
import '../../utils/constant/storage_util.dart';

class JadwalKapalAccController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoading = Rx<bool>(false);

  final jadwalRepo = Get.put(JadwalKapalAccRepository());
  RxList<JadwalKapalAccModel> jadwalKapalAccModel = <JadwalKapalAccModel>[].obs;

  int lihatRole = 0;
  int editRole = 0;

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      lihatRole = user.lihat;
      editRole = user.edit;
    }
  }

  Future<void> fetchJadwalKapalAcc() async {
    try {
      isLoading.value = true;
      final dataJadwalAcc = await jadwalRepo.fetchJadwalContent();

      jadwalKapalAccModel.assignAll(dataJadwalAcc);
    } catch (e) {
      jadwalKapalAccModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }
}
