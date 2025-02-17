import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../helpers/helper_func.dart';
import '../../models/dooring/detail_defect_model.dart';
import '../../models/user_model.dart';
import '../../repository/dooring/detail_defect_repo.dart';
import '../../repository/dooring/kapal_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import 'kapal_controller.dart';

class DetailDefectController extends GetxController {
  final detailDefectRepo = Get.put(DetailDefectRepository());
  final storageUtil = StorageUtil();
  final isLoading = Rx<bool>(false);

  RxList<DetailDefectModel> detailModel = <DetailDefectModel>[].obs;
  final networkManager = Get.find<NetworkManager>();
  GlobalKey<FormState> detailDefectKey = GlobalKey<FormState>();
  String tipeUser = '';

  TextEditingController nomorContainerController = TextEditingController();
  TextEditingController nomorMesinController = TextEditingController();
  TextEditingController nomorRangkaController = TextEditingController();
  RxInt jumlahInput = 0.obs;

  final deleteDefectRepo = Get.put(TypeMotorRepository());
  final defectController = Get.put(TypeMotorController());

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      tipeUser = user.username;
    }
  }

  Future<void> fetchDetailDefect(int idDefect) async {
    try {
      isLoading.value = true;
      final dataMotor =
          await detailDefectRepo.fectDetailDefectContent(idDefect);
      detailModel.assignAll(dataMotor);

      if (detailModel.first.jumlahInput != 0) {
        jumlahInput.value = detailModel.length;
      } else {
        jumlahInput.value = 0; // Atau nilai default lainnya
      }
    } catch (e) {
      detailModel.assignAll([]);
      jumlahInput.value = 0; // Atau nilai default lainnya
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDetailDefect(
    int idDefect,
    int idDooring,
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

    if (!detailDefectKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    bool isDuplicate = detailModel.any((data) =>
        data.noMesin == nomorMesinController.text &&
        data.noRangka ==
            nomorRangkaController.text); //nama kapal, etd, nama wilayah

    if (isDuplicate) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message:
            'Data nama pelayaran dan ETD sudah ada, mohon di cek kembali🙄',
      );
      return;
    }

    await detailDefectRepo.addDetailDefect(
      idDefect,
      idDooring,
      CustomHelperFunctions.formattedTime,
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()),
      tipeUser,
      nomorMesinController.text,
      nomorRangkaController.text,
      nomorContainerController.text,
    );

    // Fetch updated data
    await fetchDetailDefect(idDefect);

    nomorContainerController.clear();
    nomorMesinController.clear();
    nomorRangkaController.clear();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> deleteDetailDefect(int idDetail, int idDefect) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    await detailDefectRepo.deleteDetailDefect(idDetail);

    await fetchDetailDefect(idDefect);
    CustomHelperFunctions.stopLoading();
  }

  // delete table defect
  Future<void> deleteDefectTable(int idDefect, int idDooring) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    await deleteDefectRepo.deleteDefect(idDefect);
    await defectController.fetchDefetchTable(idDooring);

    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  // Edit table detail defect
  Future<void> editDefectTable(
    int idDetail,
    int idDooring,
    int idDefect,
    String noMesin,
    String noRangka,
    String noCt,
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

    await deleteDefectRepo.editDefect(
      idDetail,
      idDooring,
      idDefect,
      noMesin,
      noRangka,
      noCt,
    );
    await fetchDetailDefect(idDefect);

    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  // selesai detail defect
  Future<void> selesaiDetailDefect(int idDefect, int idDooring) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    await detailDefectRepo.selesaiDetailDefect(idDefect);
    await defectController.fetchDefetchTable(idDooring);
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }
}
