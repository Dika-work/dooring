import 'dart:convert';

import 'package:dooring/utils/constant/storage_util.dart';
import 'package:http/http.dart' as http;

import '../../models/dooring/jadwal_kapal_acc_model.dart';

class JadwalKapalAccRepository {
  final storageUtil = StorageUtil();

  Future<List<JadwalKapalAccModel>> fetchJadwalContent() async {
    final response = await http.get(Uri.parse('${storageUtil.baseURL}/'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => JadwalKapalAccModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }
}
