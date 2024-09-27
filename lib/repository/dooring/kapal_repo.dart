import 'dart:convert';

import 'package:dooring/helpers/helper_func.dart';
import 'package:http/http.dart' as http;
import '../../models/dooring/defect_model.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/snackbar.dart';

class KapalRepository {
  final storageUtil = StorageUtil();

  Future<List<KapalModel>> fetchKapalContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/kapal.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('..INI RESPONSE KENDARAAN.. : ${list.toList()}');
      return list.map((model) => KapalModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }
}

class WilayahRepository {
  final storageUtil = StorageUtil();

  Future<List<WilayahModel>> fetchWilayahContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/wilayah.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('..INI RESPONSE KENDARAAN.. : ${list.toList()}');
      return list.map((model) => WilayahModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }
}

class TypeMotorRepository {
  final storageUtil = StorageUtil();

  Future<List<TypeMotorModel>> fetchTypeMotorContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/type_motor.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('..INI RESPONSE KENDARAAN.. : ${list.toList()}');
      return list.map((model) => TypeMotorModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  Future<List<DefectModel>> fetchDefectTableContent(int idDooring) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/defect.php?action=Tabel&id_dooring=$idDooring'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DefectModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  // add defect
  Future<void> addDefect(
    int idDooring,
    String jam,
    String tgl,
    String user,
    String typeMotor,
    String part,
    int jumlah,
  ) async {
    try {
      final response = await http
          .post(Uri.parse('${storageUtil.baseURL}/defect.php'), body: {
        'id_dooring': idDooring.toString(),
        'jam': jam,
        'tgl': tgl,
        'user': user,
        'type_motor': typeMotor,
        'part': part,
        'jumlah': jumlah.toString(),
      });

      if (response.statusCode == 200) {
        SnackbarLoader.successSnackBar(
          title: 'Berhasil✨',
          message: 'Menambahkan data do global baru..',
        );
      } else if (response.statusCode != 200) {
        CustomHelperFunctions.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message: 'Pastikan telah terkoneksi dengan internet😁',
        );
      } else {
        SnackbarLoader.errorSnackBar(
          title: 'Error',
          message: 'Something went wrong, please contact developer🥰',
        );
      }
    } catch (e) {
      CustomHelperFunctions.stopLoading();
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Terjadi error: $e',
      );
      return;
    }
  }
}

class PartMotorRepository {
  final storageUtil = StorageUtil();

  Future<List<PartMotorModel>> fetchPartMotorContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/part_motor.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('..INI RESPONSE KENDARAAN.. : ${list.toList()}');
      return list.map((model) => PartMotorModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }
}
