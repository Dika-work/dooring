import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../helpers/helper_func.dart';
import '../../models/dooring/dooring_model.dart';
import '../../models/user_model.dart';
import '../../repository/dooring/dooring_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import 'kapal_controller.dart';

class DooringController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoading = Rx<bool>(false);
  RxList<DooringModel> dooringModel = <DooringModel>[].obs;
  RxList<DooringModel> originalDooringModel = <DooringModel>[].obs;

  RxList<AllDooringModel> allDooringModel = <AllDooringModel>[].obs;
  RxList<AllDooringModel> originalAllDooringModel = <AllDooringModel>[].obs;

  final dooringRepo = Get.put(DooringRepository());
  final kapalController = Get.put(KapalController());
  final wilayahController = Get.put(WilayahController());

  GlobalKey<FormState> dooringKey = GlobalKey<FormState>();
  final isConnected = Rx<bool>(true);
  final networkManager = Get.find<NetworkManager>();

  String roleUser = '';
  String roleWilayah = '';
  String nameUser = '';
  int lihatRole = 0;
  int tambahRole = 0;
  int editRole = 0;

  bool get isAdmin => roleUser == 'admin';

  final statusDefect = 'Pilih Kondisi Defect'.obs;
  final Map<String, int> listStatusDefect = {
    'Pilih Kondisi Defect': 0,
    'Ada': 1,
    'Tidak Ada': 3,
  };

  int get getStatusDefect => listStatusDefect[statusDefect.value] ?? 0;

  // edit dooring
  final statusEditDefect = 'Ada'.obs;
  final Map<String, int> listStatusEditDefect = {
    'Ada': 1,
    'Tidak Ada': 3,
  };

  int get getEditStatusDefect =>
      listStatusEditDefect[statusEditDefect.value] ?? 0;

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      roleWilayah = user.wilayah;
      roleUser = user.tipe;
      nameUser = user.username;
      lihatRole = user.lihat;
      tambahRole = user.tambah;
      editRole = user.edit;
    }
  }

  // filterisasi table sesuai dengan nama kapal yg dicari
  void filterJadwalKapalByNamaKapal(String namaKapal) {
    if (namaKapal.isEmpty) {
      // Jika tidak ada kapal yang dipilih, reset ke data asli
      dooringModel.assignAll(originalDooringModel);
    } else {
      // Filter berdasarkan nama kapal
      dooringModel.assignAll(
        originalDooringModel
            .where((item) => item.namaKapal == namaKapal)
            .toList(),
      );
    }
  }

  Future<void> fetchDooringData() async {
    try {
      print('ini wilayah user nya: $roleWilayah');
      isLoading.value = true;
      final dataDooring = await dooringRepo.fetchDooringContent();

      if (isAdmin) {
        // Jika admin, tampilkan semua data
        dooringModel.assignAll(dataDooring);
        originalDooringModel.assignAll(dataDooring); // Simpan data asli
      } else {
        // Jika bukan admin, filter data berdasarkan wilayah user
        final filteredData =
            dataDooring.where((item) => item.wilayah == roleWilayah).toList();
        dooringModel.assignAll(filteredData);
        originalDooringModel.assignAll(filteredData); // Simpan data asli
      }
    } catch (e) {
      // Jika terjadi error, kosongkan model dan data asli
      dooringModel.assignAll([]);
      originalDooringModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  // --> ini bagian seluruh dooring
  void filterAllJadwalKapalByNamaKapal(String namaKapal) {
    if (namaKapal.isEmpty) {
      // Jika tidak ada kapal yang dipilih, reset ke data asli
      allDooringModel.assignAll(originalAllDooringModel);
    } else {
      // Filter berdasarkan nama kapal
      allDooringModel.assignAll(
        originalAllDooringModel
            .where((item) => item.namaKapal == namaKapal)
            .toList(),
      );
    }
  }

  Future<void> fetchAllDooringData() async {
    try {
      isLoading.value = true;
      final dataDooring = await dooringRepo.fetchAllDooringContent();
      if (isAdmin) {
        allDooringModel.assignAll(dataDooring);
        originalAllDooringModel.assignAll(dataDooring); // Simpan data asli
      } else {
        final filteredData =
            dataDooring.where((item) => item.wilayah == roleWilayah).toList();
        allDooringModel.assignAll(filteredData);
        originalAllDooringModel.assignAll(filteredData); // Simpan data asli
      }
    } catch (e) {
      allDooringModel.assignAll([]);
      originalAllDooringModel.assignAll([]); // Pastikan data asli juga kosong
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editDooring(
    int idDooring,
    String namaKapal,
    String wilayah,
    String etd,
    String atd,
    String tglBongkar,
    int unit,
    String ct20,
    String ct40,
    int helm1,
    int accu1,
    int spion1,
    int buser1,
    int toolset1,
  ) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    if (!dooringKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    await dooringRepo.editDooring(
      idDooring,
      namaKapal,
      wilayah,
      etd,
      atd,
      tglBongkar,
      unit,
      ct20,
      ct40,
      helm1,
      accu1,
      spion1,
      buser1,
      toolset1,
      getEditStatusDefect,
    );

    await fetchDooringData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> changeStatusDefect(int idDooring, int statusDefect) async {
    CustomDialogs.loadingIndicator();

    await dooringRepo.statusDefect(idDooring, statusDefect);
    await fetchDooringData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }
}
