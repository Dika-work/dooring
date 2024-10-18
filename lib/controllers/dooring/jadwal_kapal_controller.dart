import 'dart:io';

import 'package:dooring/models/dooring/jadwal_kapal_model.dart';
import 'package:dooring/repository/dooring/jadwal_kapal_repo.dart';
import 'package:dooring/utils/constant/storage_util.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/connectivity.dart';
import '../../helpers/helper_func.dart';
import '../../models/user_model.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import 'kapal_controller.dart';

class JadwalKapalController extends GetxController {
  final storageUtil = StorageUtil();
  final isLoading = Rx<bool>(false);
  final tgl =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final jumlahUnitBongkarController = TextEditingController();
  final jumlahCt20Controller = TextEditingController();
  final jumlahCt40Controller = TextEditingController();
  final hlmController = TextEditingController();
  final acController = TextEditingController();
  final ksController = TextEditingController();
  final bsController = TextEditingController();
  final tsController = TextEditingController();

  // tambah jadwal kapal textEditingController
  final etdAddJadwalKapal =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final atdAddJadwalKapal =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final totalUnitAddJadwalKapal = TextEditingController();
  final feed20AddJadwalKapal = TextEditingController();
  final feed40AddJadwalKapal = TextEditingController();

  final jadwalRepo = Get.put(JadwalKapalRepository());
  final kapalController = Get.put(KapalController());
  final wilayahController = Get.put(WilayahController());

  // add dooring
  final tglInput =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  // final tglETD =
  //     CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  // final tglATD =
  //     CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;
  final tglBongkar =
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()).obs;

  TextEditingController jumlahBongkarController = TextEditingController();
  TextEditingController ct40Controller = TextEditingController();
  TextEditingController ct20Controller = TextEditingController();

  TextEditingController helmController = TextEditingController();
  TextEditingController accuController = TextEditingController();
  TextEditingController spionController = TextEditingController();
  TextEditingController buserController = TextEditingController();
  TextEditingController toolsetController = TextEditingController();

  String nameUser = '';

  RxList<JadwalKapalModel> jadwalKapalModel = <JadwalKapalModel>[].obs;
  RxList<LihatJadwalKapalModel> lihatJadwalKapalModel =
      <LihatJadwalKapalModel>[].obs;
  final networkManager = Get.find<NetworkManager>();
  GlobalKey<FormState> jadwalKapalKey = GlobalKey<FormState>();
  GlobalKey<FormState> addDooringKey = GlobalKey<FormState>();

  String roleUser = '';
  String roleWilayah = '';

  int lihatRole = 0;
  int tambahRole = 0;
  int editRole = 0;

  bool get isAdmin => roleUser == 'admin';

  @override
  void onInit() {
    super.onInit();
    UserModel? user = storageUtil.getUserDetails();
    if (user != null) {
      nameUser = user.username;
      roleUser = user.tipe;
      roleWilayah = user.wilayah;

      lihatRole = user.lihat;
      tambahRole = user.tambah;
      editRole = user.edit;

      print('ini nilai dari lihat : $lihatRole');
      print('ini nilai dari tambah : $tambahRole');
      print('ini nilai dari edit : $editRole');
    }
  }

  Future<void> fetchJadwalKapal() async {
    try {
      isLoading.value = true;
      final dataJadwal = await jadwalRepo.fetchJadwalContent();

      if (isAdmin) {
        jadwalKapalModel.assignAll(dataJadwal);
      } else {
        jadwalKapalModel.assignAll(
            dataJadwal.where((item) => item.wilayah == roleWilayah).toList());
      }
    } catch (e) {
      jadwalKapalModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> lihatJadwalKapal(int idJadwal) async {
    try {
      isLoading.value = true;
      final dataJadwal = await jadwalRepo.lihatJadwalKapal(idJadwal);
      print("Data jadwal kapal dari API: $dataJadwal");
      lihatJadwalKapalModel.assignAll(dataJadwal);
    } catch (e) {
      print("Error mengambil data jadwal kapal: $e");
      lihatJadwalKapalModel.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDataDooring(int idJadwal, String namaKapal, String wilayah,
      String etd, String atd) async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    if (!addDooringKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    await jadwalRepo.addDooring(
        idJadwal,
        namaKapal,
        CustomHelperFunctions.formattedTime,
        tglInput.value,
        nameUser,
        wilayah,
        etd,
        atd,
        tglBongkar.value,
        int.parse(jumlahBongkarController.text),
        int.parse(ct40Controller.text),
        int.parse(ct20Controller.text),
        int.parse(helmController.text),
        int.parse(accuController.text),
        int.parse(spionController.text),
        int.parse(buserController.text),
        int.parse(toolsetController.text));

    // Clear input fields
    jumlahBongkarController.clear();
    ct40Controller.clear();
    ct20Controller.clear();
    helmController.clear();
    accuController.clear();
    spionController.clear();
    buserController.clear();
    toolsetController.clear();

    await fetchJadwalKapal();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> addJadwalKapal() async {
    CustomDialogs.loadingIndicator();

    final isConnected = await networkManager.isConnected();
    if (!isConnected) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    if (!jadwalKapalKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    await jadwalRepo.addJadwalKapal(
      kapalController.selectedKapal.value,
      CustomHelperFunctions.formattedTime,
      CustomHelperFunctions.getFormattedDateDatabase(DateTime.now()),
      nameUser,
      wilayahController.selectedWilayah.value,
      etdAddJadwalKapal.value,
      atdAddJadwalKapal.value,
      totalUnitAddJadwalKapal.text,
      int.parse(feed20AddJadwalKapal.text),
      int.parse(feed40AddJadwalKapal.text),
    );

    // Clear input fields
    totalUnitAddJadwalKapal.clear();
    feed20AddJadwalKapal.clear();
    feed40AddJadwalKapal.clear();

    // Fetch updated data
    await fetchJadwalKapal();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> editKapalContent(
    int idJadwal,
    String namaKapal,
    String wilayah,
    String etd,
    String atd,
    int totalUnit,
    int feet20,
    int feet40,
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

    if (!jadwalKapalKey.currentState!.validate()) {
      CustomHelperFunctions.stopLoading();
      return;
    }

    await jadwalRepo.editKapal(
      idJadwal,
      namaKapal,
      wilayah,
      etd,
      atd,
      totalUnit,
      feet20,
      feet40,
    );

    await fetchJadwalKapal();
    CustomHelperFunctions.stopLoading();
    CustomHelperFunctions.stopLoading();
  }

  Future<void> downloadExcelForDooring(int idJadwal) async {
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
      await lihatJadwalKapal(idJadwal);
      print('Berhasil mengambil data dooring excel..');

      // Cek apakah detailDefectModel berisi data
      if (jadwalKapalModel.isEmpty) {
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
        TextCellValue('ATD'),
        TextCellValue('Total Unit'),
        TextCellValue('Total CT 20'),
        TextCellValue('Total CT 40'),
        TextCellValue('Wilayah'),
        TextCellValue('Helm'),
        TextCellValue('Accu'),
        TextCellValue('Spion'),
        TextCellValue('Buser'),
        TextCellValue('ToolSet'),
        TextCellValue('Type Motor'),
        TextCellValue('Part Motor'),
        TextCellValue('No Mesin'),
        TextCellValue('No Rangka'),
        TextCellValue('Jml'),
      ]);

      // Variabel untuk menambah nomor urut
      int index = 1;

      // Loop untuk menambahkan data ke dalam Excel
      for (var item in jadwalKapalModel) {
        sheetObject.appendRow([
          IntCellValue(index++), // No
          TextCellValue(item.namaKapal),
          TextCellValue(item.etd),
          TextCellValue(item.atd),
          IntCellValue(item.unit),
          IntCellValue(item.feet20),
          IntCellValue(item.feet40),
          TextCellValue(item.wilayah),
          IntCellValue(item.helmL),
          IntCellValue(item.accuL),
          IntCellValue(item.spionL),
          IntCellValue(item.buserL),
          IntCellValue(item.toolsetL),
          TextCellValue(item.typeMotor),
          TextCellValue(item.part),
          TextCellValue(item.noMesin),
          TextCellValue(item.noRangka),
          IntCellValue(item.jumlah),
        ]);
      }

      // Mendapatkan direktori eksternal (untuk penyimpanan di folder Downloads)
      Directory? directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }

      // Ambil nama kapal dan etd, gunakan fallback jika null
      var namaKapal = jadwalKapalModel.first.namaKapal;
      var etdString = jadwalKapalModel.first.etd;

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
}
