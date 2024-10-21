import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/laporan/defect_part_model.dart';
import '../../utils/constant/storage_util.dart';

class LaporanDefectRepository {
  final storageUtil = StorageUtil();

  Future<List<DefectPartModel>> fetchDefectPartRepo(
      int bulan, int tahun, String wilayah) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/laporan.php?action=defect_part&wilayah=$wilayah&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan samarinda : ${list.toList()}');
      return list.map((e) => DefectPartModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambila laporan samarinda');
    }
  }

  Future<List<DefectTypeModel>> fetchDefectTypeRepo(
      int bulan, int tahun, String wilayah) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/laporan.php?action=defect_type&wilayah=$wilayah&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan samarinda : ${list.toList()}');
      return list.map((e) => DefectTypeModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambila laporan samarinda');
    }
  }

  // ini all data dari defect type dan part
  Future<List<AllDefectPartModel>> allFetchDefectPartRepo(
      int bulan, int tahun, String wilayah) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/laporan.php?action=defect_part&wilayah=$wilayah&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan samarinda : ${list.toList()}');
      return list.map((e) => AllDefectPartModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambila laporan samarinda');
    }
  }

  Future<List<AllDefectTypeModel>> allFetchDefectTypeRepo(
      int bulan, int tahun, String wilayah) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/laporan.php?action=defect_type&wilayah=$wilayah&bulan=$bulan&tahun=$tahun'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      print('ini hasil dari laporan samarinda : ${list.toList()}');
      return list.map((e) => AllDefectTypeModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk mengambila laporan samarinda');
    }
  }
}
