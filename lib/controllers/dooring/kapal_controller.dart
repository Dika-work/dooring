import 'package:dooring/controllers/dooring/dooring_controller.dart';
import 'package:dooring/helpers/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../models/dooring/defect_model.dart';
import '../../models/dooring/dooring_model.dart';
import '../../models/dooring/kapal_model.dart';
import '../../models/user_model.dart';
import '../../repository/dooring/kapal_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';

class KapalController extends GetxController {
  final kapalRepo = Get.put(KapalRepository());
  final isLoading = Rx<bool>(false);
  RxList<KapalModel> kapalModel = <KapalModel>[].obs;
  RxString selectedKapal = ''.obs;
  RxString selectedJenisKapal = ''.obs;

  final namaPelayaran = 'CTP'.obs;
  TextEditingController namaKapalController = TextEditingController();

  final List<String> namaPelayaranMap = [
    'CTP',
    'MERATUS',
    'TANTO',
    'SPIL',
    'KALLA',
    'DUTA',
    'TEMAS',
    'ICON',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchKapalData();
  }

  Future<void> fetchKapalData() async {
    try {
      isLoading.value = true;
      final dataKapal = await kapalRepo.fetchKapalContent();
      kapalModel.assignAll(dataKapal);
    } catch (e) {
      kapalModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  List<KapalModel> get filteredKapalModel {
    if (selectedJenisKapal.value.isEmpty) {
      return kapalModel;
    }

    final filtered = kapalModel
        .where(
          (kapal) => kapal.namaKapal
              .toLowerCase()
              .contains(selectedJenisKapal.value.toLowerCase()),
        )
        .toList();

    return filtered;
  }

  void updateSelectedKendaraan(String value) {
    final kendaraan = filteredKapalModel.firstWhere(
      (kendaraan) => kendaraan.namaKapal == value,
      orElse: () => KapalModel(
        idPelayaran: 0,
        namaKapal: '',
        namaPelayaran: '',
      ),
    );

    selectedKapal.value = kendaraan.namaKapal;
  }

  void setSelectedJenisKendaraan(String jenis) {
    selectedKapal.value = jenis;
    updateSelectedKendaraan(selectedKapal.value); // Menjaga konsistensi
  }

  void resetSelectedKendaraan() {
    selectedKapal.value = '';
  }
}

class WilayahController extends GetxController {
  final wilayahRepo = Get.put(WilayahRepository());
  final isLoading = Rx<bool>(false);
  RxList<WilayahModel> wilayahModel = <WilayahModel>[].obs;

  TextEditingController namaWilayahController = TextEditingController();
  RxString selectedWilayah = ''.obs;
  RxString selectedJenisWilayah = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWilayahData();
  }

  Future<void> fetchWilayahData() async {
    try {
      isLoading.value = true;
      final dataWilayah = await wilayahRepo.fetchWilayahContent();
      wilayahModel.assignAll(dataWilayah);
    } catch (e) {
      wilayahModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  List<WilayahModel> get filteredWilayahModel {
    if (selectedJenisWilayah.value.isEmpty) {
      return wilayahModel;
    }

    final filtered = wilayahModel
        .where(
          (kapal) => kapal.wilayah
              .toLowerCase()
              .contains(selectedJenisWilayah.value.toLowerCase()),
        )
        .toList();

    return filtered;
  }

  void updateSelectedKendaraan(String value) {
    final kendaraan = filteredWilayahModel.firstWhere(
      (kendaraan) => kendaraan.wilayah == value,
      orElse: () => WilayahModel(
        idWilayah: 0,
        wilayah: '',
      ),
    );

    selectedWilayah.value = kendaraan.wilayah;
  }

  void setSelectedJenisKendaraan(String jenis) {
    selectedWilayah.value = jenis;
    updateSelectedKendaraan(selectedWilayah.value); // Menjaga konsistensi
  }

  void resetSelectedKendaraan() {
    selectedWilayah.value = '';
  }
}

class TypeMotorController extends GetxController {
  final typeMotorRepo = Get.put(TypeMotorRepository());
  final isLoading = Rx<bool>(false);
  final storageUtil = StorageUtil();
  GlobalKey<FormState> addDefectKey = GlobalKey<FormState>();
  String usernameUser = '';

  RxList<TypeMotorModel> typeMotorModel = <TypeMotorModel>[].obs;
  RxList<DefectModel> defectModel = <DefectModel>[].obs;
  RxList<DooringModel> dooringModel = <DooringModel>[].obs;

  final networkManager = Get.find<NetworkManager>();
  final dooringController = Get.put(DooringController());

  TextEditingController namaTypeMotorController = TextEditingController();
  TextEditingController jumlahDefectController = TextEditingController();
  RxString selectedMotor = ''.obs;
  RxString selectedJenisMotor = ''.obs;

  final merk = 'HONDA'.obs;
  final List<String> merkList = [
    'HONDA',
    'YAMAHA',
    'SUZUKI',
  ];

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      usernameUser = user.username;
    }
    fetchTypeMotor();
  }

  Future<void> fetchTypeMotor() async {
    try {
      isLoading.value = true;
      final dataMotor = await typeMotorRepo.fetchTypeMotorContent();
      typeMotorModel.assignAll(dataMotor);
    } catch (e) {
      typeMotorModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDefetchTable(int idDooring) async {
    try {
      isLoading.value = true;
      final dataDefect = await typeMotorRepo.fetchDefectTableContent(idDooring);
      defectModel.assignAll(dataDefect);
    } catch (e) {
      typeMotorModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDataDefect(
    int idDooring,
    String jam,
    String tgl,
    String typeMotor,
    String part,
    int jumlah,
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

    if (!addDefectKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    bool isDuplicate = defectModel.any((data) =>
        data.typeMotor.toString() == typeMotor && data.part.toString() == part);

    if (isDuplicate) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message:
            'Maaf type motor dan part motor sudah di masukkan sebelumnya 🙄',
      );
      return;
    }

    await typeMotorRepo.addDefect(
      idDooring,
      jam,
      tgl,
      usernameUser,
      typeMotor,
      part,
      jumlah,
    );
    print('Stopped loading dialog');

    await dooringController.fetchDooringData();
    CustomHelperFunctions.stopLoading();
  }

  List<TypeMotorModel> get filteredMotorModel {
    if (selectedJenisMotor.value.isEmpty) {
      return typeMotorModel;
    }

    final filtered = typeMotorModel
        .where(
          (kapal) => kapal.typeMotor
              .toLowerCase()
              .contains(selectedJenisMotor.value.toLowerCase()),
        )
        .toList();

    return filtered;
  }

  void updateSelectedKendaraan(String value) {
    final kendaraan = filteredMotorModel.firstWhere(
      (kendaraan) => kendaraan.typeMotor == value,
      orElse: () => TypeMotorModel(
        idType: 0,
        merk: '',
        typeMotor: '',
      ),
    );

    selectedMotor.value = kendaraan.typeMotor;
  }

  void setSelectedJenisKendaraan(String jenis) {
    selectedMotor.value = jenis;
    updateSelectedKendaraan(selectedMotor.value); // Menjaga konsistensi
  }

  void resetSelectedKendaraan() {
    selectedMotor.value = '';
  }
}

class PartMotorController extends GetxController {
  final partRepo = Get.put(PartMotorRepository());
  final isLoading = Rx<bool>(false);
  RxList<PartMotorModel> partMotorModel = <PartMotorModel>[].obs;

  TextEditingController namaWilayahController = TextEditingController();
  RxString selectedWilayah = ''.obs;
  RxString selectedJenisWilayah = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWilayahData();
  }

  Future<void> fetchWilayahData() async {
    try {
      isLoading.value = true;
      final dataWilayah = await partRepo.fetchPartMotorContent();
      partMotorModel.assignAll(dataWilayah);
    } catch (e) {
      partMotorModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  List<PartMotorModel> get filteredPartMotorModel {
    if (selectedJenisWilayah.value.isEmpty) {
      return partMotorModel;
    }

    final filtered = partMotorModel
        .where(
          (kapal) => kapal.namaPart
              .toLowerCase()
              .contains(selectedJenisWilayah.value.toLowerCase()),
        )
        .toList();

    return filtered;
  }

  void updateSelectedKendaraan(String value) {
    final kendaraan = filteredPartMotorModel.firstWhere(
      (kendaraan) => kendaraan.namaPart == value,
      orElse: () => PartMotorModel(
        idPart: 0,
        namaPart: '',
      ),
    );

    selectedWilayah.value = kendaraan.namaPart;
  }

  void setSelectedJenisKendaraan(String jenis) {
    selectedWilayah.value = jenis;
    updateSelectedKendaraan(selectedWilayah.value); // Menjaga konsistensi
  }

  void resetSelectedKendaraan() {
    selectedWilayah.value = '';
  }
}
