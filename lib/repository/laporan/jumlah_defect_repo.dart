import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/laporan/jumlah_defect_model.dart';
import '../../utils/constant/storage_util.dart';

class JumlahDefectRepository {
  final storageUtil = StorageUtil();

  Future<List<JumlahDefectModel>> fetchTotalUnitContent(int tahun) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/laporan.php?action=total_deffect&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan samarinda : ${list.toList()}');
      return list.map((e) => JumlahDefectModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambila laporan samarinda');
    }
  }
}
