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
  final dooringRepo = Get.put(DooringRepository());
  final kapalController = Get.put(KapalController());
  final wilayahController = Get.put(WilayahController());

  GlobalKey<FormState> dooringKey = GlobalKey<FormState>();
  final isConnected = Rx<bool>(true);
  final networkManager = Get.find<NetworkManager>();

  String tipeUser = '';
  final tglInput =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final tglETD =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final tglBongkar =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  TextEditingController jumlahUnitController = TextEditingController();

  // ksu kelebihan
  TextEditingController helmController = TextEditingController();
  TextEditingController accuController = TextEditingController();
  TextEditingController spionController = TextEditingController();
  TextEditingController buserController = TextEditingController();
  TextEditingController toolsetController = TextEditingController();
  // ksu kekurangan
  TextEditingController helmKurangController = TextEditingController();
  TextEditingController accuKurangController = TextEditingController();
  TextEditingController spionKurangController = TextEditingController();
  TextEditingController buserKurangController = TextEditingController();
  TextEditingController toolsetKurangController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      tipeUser = user.username;
    }
    fetchDooringData();
  }

  Future<void> fetchDooringData() async {
    try {
      isLoading.value = true;
      final dataDooring = await dooringRepo.fetchDooringContent();
      dooringModel.assignAll(dataDooring);
    } catch (e) {
      dooringModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDataDooring() async {
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

    bool isDuplicate = dooringModel.any((data) =>
        data.namaKapal == kapalController.selectedKapal.toString() &&
        data.etd == tglETD.toString() &&
        data.wilayah ==
            wilayahController
                .selectedWilayah.value); //nama kapal, etd, nama wilayah

    if (isDuplicate) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message:
            'Data nama pelayaran dan ETD sudah ada, mohon di cek kembali🙄',
      );
      return;
    }

    await dooringRepo.addDooring(
      kapalController.selectedKapal.value,
      CustomHelperFunctions.formattedTime,
      tglInput.value,
      tipeUser,
      wilayahController.selectedWilayah.value,
      tglETD.value,
      tglBongkar.value,
      int.parse(jumlahUnitController.text),
      int.parse(helmController.text),
      int.parse(accuController.text),
      int.parse(spionController.text),
      int.parse(buserController.text),
      int.parse(toolsetController.text),
      int.parse(helmKurangController.text),
      int.parse(accuKurangController.text),
      int.parse(spionKurangController.text),
      int.parse(buserKurangController.text),
      int.parse(toolsetKurangController.text),
    );

    // Clear input fields
    jumlahUnitController.clear();
    helmController.clear();
    accuController.clear();
    spionController.clear();
    buserController.clear();
    toolsetController.clear();
    helmKurangController.clear();
    accuKurangController.clear();
    spionKurangController.clear();
    buserKurangController.clear();
    toolsetKurangController.clear();

    // Fetch updated data
    await fetchDooringData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> editDooring(
    int idDooring,
    String namaKapal,
    String wilayah,
    String etd,
    String tglBongkar,
    int unit,
    int helm1,
    int accu1,
    int spion1,
    int buser1,
    int toolset1,
    int helmKurang,
    int accuKurang,
    int spionKurang,
    int buserKurang,
    int toolsetKurang,
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

    await dooringRepo.editDooring(
      idDooring,
      namaKapal,
      wilayah,
      etd,
      tglBongkar,
      unit,
      helm1,
      accu1,
      spion1,
      buser1,
      toolset1,
      helmKurang,
      accuKurang,
      spionKurang,
      buserKurang,
      toolsetKurang,
    );

    await fetchDooringData();
    CustomHelperFunctions.stopLoading();
  }
}
