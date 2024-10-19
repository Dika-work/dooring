import 'dart:convert';

import 'package:dooring/helpers/helper_func.dart';
import 'package:http/http.dart' as http;
import '../../models/dooring/defect_model.dart';
import '../../models/dooring/detail_defect_model.dart';
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
      return list.map((model) => WilayahModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  // edit master wilayah
  Future<void> editWilayah(
    int idWilayah,
    String wilayah,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/wilayah.php'),
        body: {
          'id_wilayah': idWilayah.toString(),
          'wilayah': wilayah,
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

class TypeMotorRepository {
  final storageUtil = StorageUtil();

  Future<List<TypeMotorModel>> fetchTypeMotorContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/type_motor.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => TypeMotorModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  // edit master type motor
  Future<void> editTypeMotor(
    int idType,
    String merk,
    String typeMotor,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/type_motor.php'),
        body: {
          'id_type': idType.toString(),
          'merk': merk,
          'type_motor': typeMotor,
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

  // delete master type motor
  Future<void> deleteTypeMotor(
    int id,
  ) async {
    try {
      print('...PROSES AWALANAN DELETE DI REPOSITORY DO Harian...');
      final response = await http.delete(
          Uri.parse('${storageUtil.baseURL}/type_motor.php'),
          body: {'id': id.toString()});

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data DO Harian berhasil dihapus',
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
              'Gagal menghapus DO Harian, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomHelperFunctions.stopLoading();
      print('Error di catch di repository do Harian: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus DO Harian',
      );
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

  Future<List<DetailDefectModel>> lihatDooringTable(int idDooring) async {
    final response = await http.get(Uri.parse(
        '${storageUtil.baseURL}/dooring.php?action=Lihat&id_dooring=$idDooring'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DetailDefectModel.fromJson(model)).toList();
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

  Future<void> editDefectData(
    int idDefect,
    int idDooring,
    String typeMotor,
    String part,
    String jumlah,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/defect.php'),
        body: {
          'id_defect': idDefect.toString(),
          'id_dooring': idDooring.toString(),
          'type_motor': typeMotor,
          'part': part,
          'jumlah': jumlah,
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

  // delete defect table
  Future<void> deleteDefect(int idDefect) async {
    try {
      final response = await http
          .delete(Uri.parse('${storageUtil.baseURL}/defect.php'), body: {
        'id_defect': idDefect.toString(),
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

  // edit detail defect table
  Future<void> editDefect(
    int idDetail,
    int idDooring,
    int idDefect,
    String noMesin,
    String noRangka,
    String noCt,
  ) async {
    try {
      final response = await http
          .put(Uri.parse('${storageUtil.baseURL}/defect_detail.php'), body: {
        'id_detail': idDetail.toString(),
        'id_dooring': idDooring.toString(),
        'id_defect': idDefect.toString(),
        'no_mesin': noMesin,
        'no_rangka': noRangka,
        'no_ct': noCt,
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

  // selesai data defect
  Future<void> selesaiDefect(int idDooring) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/dooring.php?action=Konfirmasi'),
        body: {
          'id_dooring': idDooring.toString(),
          'st_defect': '2',
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

class PartMotorRepository {
  final storageUtil = StorageUtil();

  Future<List<PartMotorModel>> fetchPartMotorContent() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/part_motor.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => PartMotorModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  // add part motor
  Future<void> addPartMotor(
    String namaPart,
  ) async {
    try {
      final response = await http
          .post(Uri.parse('${storageUtil.baseURL}/defect.php'), body: {
        'nm_part': namaPart,
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

  // edit master part
  Future<void> editPart(
    int idPart,
    String namaPart,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/part_motor.php'),
        body: {
          'id_part': idPart.toString(),
          'nm_part': namaPart,
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

class PelayaranRepository {
  final storageUtil = StorageUtil();

  Future<List<PelayaranModel>> fetchDataPelayaran() async {
    final response = await http
        .get(Uri.parse('${storageUtil.baseURL}/pelayaran.php?action=getData'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => PelayaranModel.fromJson(model)).toList();
    } else {
      throw Exception('Gagal untuk mengambil data kapal☠️');
    }
  }

  // add part motor
  Future<void> addPartMotor(String namaPelayaran) async {
    try {
      final response = await http.post(
          Uri.parse('${storageUtil.baseURL}/pelayaran.php'),
          body: {'nm_pel': namaPelayaran});

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

  // edit master part
  Future<void> editPart(
    int idPel,
    String namaPel,
  ) async {
    try {
      print('...PROSES AWALANAN DI REPOSITORY DO Global...');
      final response = await http.put(
        Uri.parse('${storageUtil.baseURL}/pelayaran.php'),
        body: {
          'id_pel': idPel.toString(),
          'nm_pel': namaPel,
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

  // delete pelayaran
  Future<void> deletePelayaran(
    int id,
  ) async {
    try {
      print('...PROSES AWALANAN DELETE DI REPOSITORY DO Harian...');
      final response = await http.delete(
          Uri.parse('${storageUtil.baseURL}/pelayaran.php'),
          body: {'id_pel': id.toString()});

      print('...BERHASIL DI REPOSITORY...');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          SnackbarLoader.successSnackBar(
            title: 'Sukses 😃',
            message: 'Data DO Harian berhasil dihapus',
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
              'Gagal menghapus DO Harian, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomHelperFunctions.stopLoading();
      print('Error di catch di repository do Harian: $e');
      SnackbarLoader.errorSnackBar(
        title: 'Gagal😪',
        message: 'Terjadi kesalahan saat menghapus DO Harian',
      );
    }
  }
}
