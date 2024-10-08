import 'package:get/get.dart';

import '../../models/laporan/total_unit_model.dart';
import '../../repository/laporan/total_unit_repo.dart';

class TotalUnitController extends GetxController {
  final isLoading = Rx<bool>(false);
  RxList<TotalUnitModel> samarindaModel = <TotalUnitModel>[].obs;
  final samarindaRepo = Get.put(TotalUnitRepository());

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
