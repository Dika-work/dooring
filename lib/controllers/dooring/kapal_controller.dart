import 'dart:io';

import 'package:dooring/helpers/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';

import '../../helpers/connectivity.dart';
import '../../models/dooring/defect_model.dart';
import '../../models/dooring/detail_defect_model.dart';
import '../../models/dooring/dooring_model.dart';
import '../../models/dooring/kapal_model.dart';
import '../../models/user_model.dart';
import '../../repository/dooring/kapal_repo.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import 'dooring_controller.dart';

class KapalController extends GetxController {
  final kapalRepo = Get.put(KapalRepository());
  final isLoading = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false);
  final isFabVisible = true.obs;

  RxList<KapalModel> kapalModel = <KapalModel>[].obs;
  RxList<KapalModel> displayedData = <KapalModel>[].obs;
  RxString selectedKapal = ''.obs;
  RxString selectedJenisKapal = ''.obs;

  // lazy loading
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 15;
  int loadMoreCount = 5;

  TextEditingController namaKapalController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchKapalData();
    scrollController.addListener(scrollListener);
  }

  Future<void> fetchKapalData() async {
    try {
      isLoading.value = true;
      final dataKapal = await kapalRepo.fetchKapalContent();
      kapalModel.assignAll(dataKapal);
      displayedData.assignAll(kapalModel.take(initialDataCount).toList());
    } catch (e) {
      kapalModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  void filterNamaKapal(String namaKapal) {
    if (namaKapal.isEmpty) {
      // Jika tidak ada kapal yang dipilih, reset ke data asli
      displayedData.assignAll(kapalModel);
    } else {
      // Filter berdasarkan nama kapal
      displayedData.assignAll(
        kapalModel.where((item) => item.namaKapal == namaKapal).toList(),
      );
    }
  }

  // lazy loading func
  void scrollListener() {
    // Ketika scroll mencapai batas bawah
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value) {
      isFabVisible.value = false; // Sembunyikan FAB
    } else if (scrollController.position.pixels <
        scrollController.position.maxScrollExtent) {
      isFabVisible.value = true; // Tampilkan FAB
    }

    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading.value &&
        !isLoadingMore.value) {
      // Load more data when reaching the bottom
      loadMoreData();
    }
  }

  void loadMoreData() {
    // Load additional data if available
    if (displayedData.length < kapalModel.length && !isLoadingMore.value) {
      print("Loading more data...");
      isLoadingMore.value = true;
      final nextData =
          kapalModel.skip(displayedData.length).take(loadMoreCount).toList();
      displayedData.addAll(nextData);

      print(
          'Additional data loaded: ${displayedData.length} items'); // Cetak jumlah data setelah load more
      isLoadingMore.value = false;
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
  final networkManager = Get.find<NetworkManager>();

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

  Future<void> editWilayah(
    int idWilayah,
    String wilayah,
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

    await wilayahRepo.editWilayah(
      idWilayah,
      wilayah,
    );

    await fetchWilayahData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
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
  final partMotorController = Get.put(PartMotorController());

  final isLoading = Rx<bool>(false);
  final isLoadingMore = Rx<bool>(false);
  final isFabVisible = true.obs;

  final storageUtil = StorageUtil();
  GlobalKey<FormState> addDefectKey = GlobalKey<FormState>();
  String usernameUser = '';

  RxList<TypeMotorModel> typeMotorModel = <TypeMotorModel>[].obs;
  RxList<TypeMotorModel> displayedData = <TypeMotorModel>[].obs;

  RxList<DefectModel> defectModel = <DefectModel>[].obs;
  RxList<DetailDefectModel> detailDefectModel = <DetailDefectModel>[].obs;
  RxList<DooringModel> dooringModel = <DooringModel>[].obs;

  // lazy loading
  final ScrollController scrollController = ScrollController();
  int initialDataCount = 15;
  int loadMoreCount = 5;

  final networkManager = Get.find<NetworkManager>();
  final dooringController = Get.put(DooringController());

  TextEditingController namaTypeMotorController = TextEditingController();
  TextEditingController jumlahDefectController = TextEditingController();
  TextEditingController editJumlahDefectController = TextEditingController();
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
    scrollController.addListener(scrollListener);
  }

  Future<void> fetchTypeMotor() async {
    try {
      isLoading.value = true;
      final dataMotor = await typeMotorRepo.fetchTypeMotorContent();
      typeMotorModel.assignAll(dataMotor);
      displayedData.assignAll(typeMotorModel.take(initialDataCount).toList());
    } catch (e) {
      typeMotorModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editTypeMotor(
    int idType,
    String merk,
    String typeMotor,
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

    await typeMotorRepo.editTypeMotor(
      idType,
      merk,
      typeMotor,
    );

    await fetchTypeMotor();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> hapusTypeMotor(int id) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }
    await typeMotorRepo.deleteTypeMotor(id);

    await fetchTypeMotor();
    CustomHelperFunctions.stopLoading();
  }

  // lazy loading func
  void scrollListener() {
    // Ketika scroll mencapai batas bawah
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value) {
      isFabVisible.value = false; // Sembunyikan FAB
    } else if (scrollController.position.pixels <
        scrollController.position.maxScrollExtent) {
      isFabVisible.value = true; // Tampilkan FAB
    }

    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading.value &&
        !isLoadingMore.value) {
      // Load more data when reaching the bottom
      loadMoreData();
    }
  }

  void loadMoreData() {
    // Load additional data if available
    if (displayedData.length < typeMotorModel.length && !isLoadingMore.value) {
      print("Loading more data...");
      isLoadingMore.value = true;
      final nextData = typeMotorModel
          .skip(displayedData.length)
          .take(loadMoreCount)
          .toList();
      displayedData.addAll(nextData);

      print(
          'Additional data loaded: ${displayedData.length} items'); // Cetak jumlah data setelah load more
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchDefetchTable(int idDooring) async {
    try {
      isLoading.value = true;
      final dataDefect = await typeMotorRepo.fetchDefectTableContent(idDooring);
      defectModel.assignAll(dataDefect);
    } catch (e) {
      defectModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> lihatDooring(int idDooring) async {
    try {
      isLoading.value = true;
      final dataDefect = await typeMotorRepo.lihatDooringTable(idDooring);
      detailDefectModel.assignAll(dataDefect);
    } catch (e) {
      detailDefectModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadExcelForDooring(int idDooring) async {
    try {
      print('Ini awalan download excel');
      CustomDialogs.loadingIndicator();

      // Cek koneksi internet
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        CustomHelperFunctions.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia',
        );
        return;
      }

      // Fetch data dari lihatDooring
      await lihatDooring(idDooring);
      print('Berhasil mengambil data dooring excel..');

      // Cek apakah detailDefectModel berisi data
      if (detailDefectModel.isEmpty) {
        CustomHelperFunctions.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Data kosong, tidak ada yang bisa diunduh',
        );
        return;
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      print('Proses ekstraksi..');

      // Menambahkan header ke dalam Excel
      sheetObject.appendRow([
        TextCellValue('No'),
        TextCellValue('Nama Kapal'),
        TextCellValue('ETD'),
        TextCellValue('Tgl Bongkar'),
        TextCellValue('Total Unit'),
        TextCellValue('Type Motor'),
        TextCellValue('Part Motor'),
        TextCellValue('No Mesin'),
        TextCellValue('No Rangka'),
        TextCellValue('No CT'),
      ]);

      int index = 1;

      // Loop untuk menambahkan data ke dalam Excel
      for (var item in detailDefectModel) {
        sheetObject.appendRow([
          IntCellValue(index++),
          TextCellValue(item.namaKapal),
          TextCellValue(item.etd),
          TextCellValue(item.tglBongkar),
          IntCellValue(item.unit),
          TextCellValue(item.typeMotor),
          TextCellValue(item.part),
          TextCellValue(item.noMesin),
          TextCellValue(item.noRangka),
          TextCellValue(item.noCT),
        ]);
      }

      // Mendapatkan direktori eksternal (untuk penyimpanan di folder Downloads)
      Directory? directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }

      // Ambil nama kapal dan etd, gunakan fallback jika null
      var namaKapal = detailDefectModel.first.namaKapal;
      var etdString = detailDefectModel.first.etd;

      // Coba simpan file Excel
      var fileBytes = excel.save();

      // Pastikan fileBytes tidak null sebelum menulis ke file
      if (fileBytes == null) {
        CustomHelperFunctions.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Gagal menyimpan file Excel, data tidak valid',
        );
        return;
      }

      // Format path penyimpanan menggunakan direktori Downloads
      String filePath = join(directory!.path, '$namaKapal $etdString.xlsx');

      // Simpan file Excel
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // Tampilkan pesan sukses
      SnackbarLoader.successSnackBar(
        title: 'Success',
        message: 'File berhasil disimpan',
      );

      print('Berhasil menyimpan file excel pada direktori ${directory.path}');

      // Membuka file secara otomatis setelah disimpan
      OpenFile.open(filePath);

      CustomHelperFunctions.stopLoading();
    } catch (e) {
      // Tangkap semua error dan tampilkan pesan error
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengunduh file excel: $e',
      );
      print('Ini err nya: $e');
      CustomHelperFunctions.stopLoading();
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
    selectedMotor.value = '';
    partMotorController.selectedWilayah.value = '';
    jumlahDefectController.clear();
    await fetchDefetchTable(idDooring);
    CustomHelperFunctions.stopLoading();
  }

  Future<void> editDataDefect(
    int idDefect,
    int idDooring,
    String typeMotor,
    String part,
    String jumlah,
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

    await typeMotorRepo.editDefectData(
      idDefect,
      idDooring,
      typeMotor,
      part,
      jumlah,
    );
    await fetchDefetchTable(idDooring);
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> selesaiDefect(int idDooring) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    await typeMotorRepo.selesaiDefect(idDooring);
    await dooringController.fetchDooringData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
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
  final networkManager = Get.find<NetworkManager>();
  final isLoading = Rx<bool>(false);
  GlobalKey<FormState> addPartKey = GlobalKey<FormState>();
  RxList<PartMotorModel> partMotorModel = <PartMotorModel>[].obs;

  TextEditingController partMotorController = TextEditingController();
  RxString selectedWilayah = ''.obs;
  RxString selectedJenisWilayah = ''.obs;

  final ScrollController scrollController = ScrollController();
  final isFabVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWilayahData();
    scrollController.addListener(scrollListener);
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

  void scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      // Hide FAB when reaching the bottom
      isFabVisible.value = false;
    } else {
      // Show FAB when scrolling up
      isFabVisible.value = true;
    }
  }

  Future<void> addPartMotor(String namaPart) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    if (!addPartKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    await partRepo.addPartMotor(namaPart);
    partMotorController.clear();

    await fetchWilayahData();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> editPart(
    int idPart,
    String namaPart,
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

    await partRepo.editPart(
      idPart,
      namaPart,
    );

    await fetchWilayahData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
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

class PelayaranController extends GetxController {
  final pelayaranRepo = Get.put(PelayaranRepository());
  final networkManager = Get.find<NetworkManager>();
  final isLoading = Rx<bool>(false);
  GlobalKey<FormState> addPartKey = GlobalKey<FormState>();
  RxList<PelayaranModel> pelayaranModel = <PelayaranModel>[].obs;

  TextEditingController namaPelayaran = TextEditingController();
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
      final dataWilayah = await pelayaranRepo.fetchDataPelayaran();
      pelayaranModel.assignAll(dataWilayah);
    } catch (e) {
      pelayaranModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPartMotor(String namaPart) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    if (!addPartKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    await pelayaranRepo.addPartMotor(namaPart);
    print('Stopped loading dialog');

    await fetchWilayahData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> editPart(
    int idPart,
    String namaPart,
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

    await pelayaranRepo.editPart(
      idPart,
      namaPart,
    );

    await fetchWilayahData();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> deletePelayaran(int id) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }
    await pelayaranRepo.deletePelayaran(id);

    await fetchWilayahData();
    namaPelayaran.clear();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  List<PelayaranModel> get filteredPartMotorModel {
    if (selectedJenisWilayah.value.isEmpty) {
      return pelayaranModel;
    }

    final filtered = pelayaranModel
        .where(
          (kapal) => kapal.namaPel
              .toLowerCase()
              .contains(selectedJenisWilayah.value.toLowerCase()),
        )
        .toList();

    return filtered;
  }

  void updateSelectedKendaraan(String value) {
    final kendaraan = filteredPartMotorModel.firstWhere(
      (kendaraan) => kendaraan.namaPel == value,
      orElse: () => PelayaranModel(
        idPelayaran: 0,
        namaPel: '',
      ),
    );

    selectedWilayah.value = kendaraan.namaPel;
  }

  void setSelectedJenisKendaraan(String jenis) {
    selectedWilayah.value = jenis;
    updateSelectedKendaraan(selectedWilayah.value); // Menjaga konsistensi
  }

  void resetSelectedKendaraan() {
    selectedWilayah.value = '';
  }
}
