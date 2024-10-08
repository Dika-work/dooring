import 'package:get/get.dart';

import '../../models/laporan/defect_part_model.dart';
import '../../repository/laporan/laporan_defect_repo.dart';

class LaporanDefectController extends GetxController {
  final isLoading = Rx<bool>(false);
  RxList<DefectPartModel> defectPartModel = <DefectPartModel>[].obs;
  RxList<DefectTypeModel> defectTypeModel = <DefectTypeModel>[].obs;
  final samarindaRepo = Get.put(LaporanDefectRepository());

  Future<void> fetchDefectPart(int bulan, int tahun, String wilayah) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.fetchDefectPartRepo(bulan, tahun, wilayah);
      defectPartModel.assignAll(getLaporanSamarinda);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan samarinda');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDefectType(int bulan, int tahun, String wilayah) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.fetchDefectTypeRepo(bulan, tahun, wilayah);
      defectTypeModel.assignAll(getLaporanSamarinda);
    } catch (e) {
      throw Exception('Gagal mengambil data laporan samarinda');
    } finally {
      isLoading.value = false;
    }
  }
}
