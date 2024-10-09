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
      print('Data yang diterima di controller: $getLaporanSamarinda');
      samarindaModel.assignAll(getLaporanSamarinda);
      print('samarindaModel setelah assignAll: $samarindaModel');
    } catch (e) {
      print('Error saat fetch data: $e');
      throw Exception('$e');
    } finally {
      isLoading.value = false;
    }
  }
}
