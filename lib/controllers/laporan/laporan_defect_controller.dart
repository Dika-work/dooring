import 'package:get/get.dart';

import '../../models/laporan/defect_part_model.dart';
import '../../repository/laporan/laporan_defect_repo.dart';

class LaporanDefectController extends GetxController {
  final isLoading = Rx<bool>(false);
  RxList<DefectPartModel> defectPartModel = <DefectPartModel>[].obs;
  RxList<DefectTypeModel> defectTypeModel = <DefectTypeModel>[].obs;

  RxList<AllDefectPartModel> allDefectPartModel = <AllDefectPartModel>[].obs;
  RxList<AllDefectTypeModel> allDefectTypeModel = <AllDefectTypeModel>[].obs;
  final samarindaRepo = Get.put(LaporanDefectRepository());

  // Fetch and sort Defect Part (Top 10 by Total Defect)
  Future<void> fetchDefectPart(int bulan, int tahun, String wilayah) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.fetchDefectPartRepo(bulan, tahun, wilayah);

      // Assign all fetched data
      defectPartModel.assignAll(getLaporanSamarinda);

      // Sort by Total Defect in descending order and take top 10
      defectPartModel.sort((a, b) => b.total.compareTo(a.total));
      defectPartModel.assignAll(defectPartModel.take(10).toList());
    } catch (e) {
      throw Exception('Gagal mengambil data laporan samarinda');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch and sort Defect Type (Top 10 by Total Defect)
  Future<void> fetchDefectType(int bulan, int tahun, String wilayah) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.fetchDefectTypeRepo(bulan, tahun, wilayah);

      // Assign all fetched data
      defectTypeModel.assignAll(getLaporanSamarinda);

      // Sort by Total Defect in descending order and take top 10
      defectTypeModel.sort((a, b) => b.total.compareTo(a.total));
      defectTypeModel.assignAll(defectTypeModel.take(10).toList());
    } catch (e) {
      throw Exception('Gagal mengambil data laporan samarinda');
    } finally {
      isLoading.value = false;
    }
  }

  // ini all data dari defect type dan part
  Future<void> allFetchDefectPart(int bulan, int tahun, String wilayah) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.allFetchDefectPartRepo(bulan, tahun, wilayah);
      allDefectPartModel.assignAll(getLaporanSamarinda);
    } catch (e) {
      return allDefectPartModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> allFetchDefectType(int bulan, int tahun, String wilayah) async {
    try {
      isLoading.value = true;
      final getLaporanSamarinda =
          await samarindaRepo.allFetchDefectTypeRepo(bulan, tahun, wilayah);
      allDefectTypeModel.assignAll(getLaporanSamarinda);
    } catch (e) {
      return allDefectTypeModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }
}
