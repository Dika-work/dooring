import 'dart:convert';

import 'package:dooring/helpers/helper_func.dart';
import 'package:http/http.dart' as http;
import '../../models/dooring/dooring_model.dart';
import '../../utils/constant/storage_util.dart';
import '../../utils/popups/snackbar.dart';

class DooringRepository {
  final storageUtil = StorageUtil();

  Future<List<DooringModel>> fetchDooringContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/dooring.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DooringModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  Future<List<AllDooringModel>> fetchAllDooringContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/dooring.php?action=getDataAll'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => AllDooringModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
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
    int statusDefect,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/dooring.php'),
        body: {
          'id_dooring': idDooring.toString(),
          'nm_kapal': namaKapal,
          'wilayah': wilayah,
          'etd': etd,
          'atd': atd,
          'tgl_bongkar': tglBongkar,
          'unit': unit.toString(),
          'ct_20': ct20,
          'ct_40': ct40,
          'helm_l': helm1.toString(),
          'accu_l': accu1.toString(),
          'spion_l': spion1.toString(),
          'buser_l': buser1.toString(),
          'toolset_l': toolset1.toString(),
          'st_defect': statusDefect.toString(),
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

  Future<void> statusDefect(int idDooring, int statusDefect) async {
    try {
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/dooring.php?action=Konfirmasi'),
        body: {
          'id_dooring': idDooring.toString(),
          'st_defect': statusDefect.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Type motor berhasil diubah',
          );
        } else {
          CustomHelperFunctions.stopLoading();
          SnackbarLoader.errorSnackBar(
            title: 'Gagal😪',
            message: responseData['message'] ?? 'Ada yang salah🤷',
          );
          print('...ADA MASALAH DI EDIT TYPE MOTOR REPO...');
        }
        return responseData;
      } else {
        CustomHelperFunctions.stopLoading();
        SnackbarLoader.errorSnackBar(
          title: 'Gagal😪',
          message:
              'Gagal mengedit Type motor, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomHelperFunctions.stopLoading();
      print('Error edit di repository Edit Type Motor: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat mengedit Type motor',
      );
    }
  }
}
