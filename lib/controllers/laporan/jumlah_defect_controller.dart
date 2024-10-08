import 'package:get/get.dart';

import '../../models/laporan/jumlah_defect_model.dart';
import '../../repository/laporan/jumlah_defect_repo.dart';

class JumlahDefectController extends GetxController {
  final isLoading = Rx<bool>(false);
  RxList<JumlahDefectModel> samarindaModel = <JumlahDefectModel>[].obs;
  final samarindaRepo = Get.put(JumlahDefectRepository());

  Future<void> fetchTotalUnitData(int tahun) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.fetchTotalUnitContent(tahun);
      samarindaModel.assignAll(getLaporanSamarinda);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan samarinda');
    } finally {
      isLoading.value = false;
    }
  }
}
