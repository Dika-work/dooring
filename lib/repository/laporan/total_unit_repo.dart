import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/laporan/total_unit_model.dart';
import '../../utils/constant/storage_util.dart';

class TotalUnitRepository {
  final storageUtil = StorageUtil();

  Future<List<TotalUnitModel>> fetchTotalUnitContent(int tahun) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/laporan.php?action=total_unit&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan samarinda : ${list.toList()}');
      return list.map((e) => TotalUnitModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambila laporan samarinda');
    }
  }
}
