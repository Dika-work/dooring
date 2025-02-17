import 'dart:convert';

import 'package:dooring/helpers/helper_func.dart';
import 'package:dooring/models/dooring/detail_defect_model.dart';
import 'package:dooring/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../utils/popups/snackbar.dart';

class DetailDefectRepository {
  final storageUtil = StorageUtil();

  Future<List<DetailDefectModel>> fectDetailDefectContent(int idDefect) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/defect_detail.php?action=Tabel&id_defect=$idDefect'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini response json dari id $idDefect: ${list.toList()}');
      return list.map((model) => DetailDefectModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  Future<void> addDetailDefect(
      int idDefect,
      int idDooring,
      String jam,
      String tgl,
      String user,
      String noMesin,
      String noRangka,
      String noContainer) async {
    try {
      final response = await http
          .post(Uri.parse('${storageUtil.baseURL}/defect_detail.php'), body: {
        'id_defect': idDefect.toString(),
        'id_dooring': idDooring.toString(),
        'jam': jam,
        'tgl': tgl,
        'user': user,
        'no_mesin': noMesin,
        'no_rangka': noRangka,
        'no_ct': noContainer,
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

  Future<void> deleteDetailDefect(int idDetail) async {
    try {
      final response = await http
          .delete(Uri.parse('${storageUtil.baseURL}/defect_detail.php'), body: {
        'id_detail': idDetail.toString(),
      });

      if (response.statusCode == 200) {
        SnackbarLoader.successSnackBar(
          title: 'Delete Defect✅',
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

  Future<void> selesaiDetailDefect(int idDefectint) async {
    try {
      final response = await http.put(
          Uri.parse('${storageUtil.baseURL}/defect.php?action=selesai'),
          body: {
            'id_defect': idDefectint.toString(),
            'st_detail': '1',
          });
      if (response.statusCode != 200) {
        print('Failed to mark as selesai: ${response.body}');
        throw Exception('Failed to mark as selesai');
      } else {
        print('Marked as selesai successfully: ${response.body}');
      }
    } catch (e) {
      print('Error in accSelesai: $e');
      throw Exception('Something went wrong, please contact developer');
    }
  }
}
