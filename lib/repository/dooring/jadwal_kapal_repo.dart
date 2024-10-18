import 'dart:convert';

import 'package:dooring/helpers/helper_func.dart';
import 'package:http/http.dart' as http;

import '../../models/dooring/jadwal_kapal_model.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/snackbar.dart';

class JadwalKapalRepository {
  final storageUtil = StorageUtil();

  Future<List<JadwalKapalModel>> fetchJadwalContent() async {
    final response = await http.get(
        Uri.parse('${storageUtil.baseURL}/jadwal_kapal.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => JadwalKapalModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  Future<List<LihatJadwalKapalModel>> lihatJadwalKapal(int idJadwal) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/jadwal_kapal.php?action=Lihat&id_jadwal=$idJadwal'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini response json nya : ${list.toList()}');
      return list
          .map((model) => LihatJadwalKapalModel.fromJson(model))
          .toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  Future<void> addDooring(
    int idJadwal,
    String namaKapal,
    String jam,
    String tgl,
    String user,
    String wilayah,
    String etd,
    String atd,
    String tglBongkar,
    int unit,
    int ct40,
    int ct20,
    int helm1,
    int accu1,
    int spion1,
    int buser1,
    int toolset1,
  ) async {
    try {
      final response = await http
          .post(Uri.parse('${storageUtil.baseURL}/dooring.php'), body: {
        'id_jadwal': idJadwal.toString(),
        'nm_kapal': namaKapal,
        'jam': jam,
        'tgl': tgl,
        'user': user,
        'wilayah': wilayah,
        'etd': etd,
        'atd': atd,
        'tgl_bongkar': tglBongkar,
        'unit': unit.toString(),
        'ct_40': ct40.toString(),
        'ct_20': ct20.toString(),
        'helm_l': helm1.toString(),
        'accu_l': accu1.toString(),
        'spion_l': spion1.toString(),
        'buser_l': buser1.toString(),
        'toolset_l': toolset1.toString(),
        'st_input': '1',
      });

      if (response.statusCode == 200) {
        SnackbarLoader.successSnackBar(
          title: 'Berhasil✨',
          message: 'Menambahkan data do harian baru..',
        );
      } else if (response.statusCode != 200) {
        CustomHelperFunctions.stopLoading();
        print('Something went wrong here');
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
      print(e);
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan internet 😁',
      );
      return;
    }
  }

  Future<void> addJadwalKapal(
    String namaKapal,
    String jam,
    String tgl,
    String user,
    String wilayah,
    String etd,
    String atd,
    String totalUnit,
    int feet20,
    int feet40,
  ) async {
    try {
      final response = await http
          .post(Uri.parse('${storageUtil.baseURL}/jadwal_kapal.php'), body: {
        'nm_kapal': namaKapal,
        'jam': jam,
        'tgl': tgl,
        'user': user,
        'wilayah': wilayah,
        'etd': etd,
        'atd': atd,
        'total_unit': totalUnit,
        'feet_20': feet20.toString(),
        'feet_40': feet40.toString(),
      });

      if (response.statusCode == 200) {
        SnackbarLoader.successSnackBar(
          title: 'Berhasil✨',
          message: 'Menambahkan data do harian baru..',
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
      SnackbarLoader.errorSnackBar(
        title: 'Error☠️',
        message: 'Pastikan sudah terhubung dengan internet 😁',
      );
      return;
    }
  }

  Future<void> editKapal(
    int idJadwal,
    String namaKapal,
    String wilayah,
    String etd,
    String atd,
    int totalUnit,
    int feet20,
    int feet40,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/jadwal_kapal.php?action=Edit'),
        body: {
          'id_jadwal': idJadwal.toString(),
          'nm_kapal': namaKapal,
          'wilayah': wilayah,
          'etd': etd,
          'atd': atd,
          'total_unit': totalUnit.toString(),
          'feet_20': feet20.toString(),
          'feet_40': feet40.toString(),
        },
      );

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'DO Global berhasil diubah',
          );
        } else {
          CustomHelperFunctions.stopLoading();
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message: responseData['message'] ?? 'Ada yang salah🤷',
          );
        }
        return responseData;
      } else {
        CustomHelperFunctions.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal mengedit DO Global, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomHelperFunctions.stopLoading();
      print('Error di catch di repository do Global: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit DO Global',
      );
    }
  }
}
