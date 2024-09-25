import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

import '../helpers/helper_func.dart';
import '../models/user_model.dart';
import '../utils/constant/storage_util.dart';
import '../utils/popups/snackbar.dart';

class LoginRepository {
  final storageUtil = Get.put(StorageUtil());
  final storage = GetStorage(); // Tambahkan GetStorage untuk menyimpan data

  Future<UserModel?> fetchUserDetails(String username, String password,
      {String? redirectRoute}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${storageUtil.baseURL}/DO/api/api_user.php?action=Login&username=$username&password=$password',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          final user = UserModel.fromJson(data['data']);

          // Simpan user data atau token ke GetStorage
          storage.write('userToken',
              data['token']); // Sesuaikan dengan key token dari API

          storageUtil.saveUserDetails(user);

          // Arahkan ke rute sesuai redirectRoute jika ada
          if (redirectRoute != null && redirectRoute.isNotEmpty) {
            Get.offAllNamed(redirectRoute);
          } else {
            Get.offAllNamed('/rootpage');
          }

          return user;
        } else {
          showErrorSnackbar('Gagal😪', 'Username dan password salah..😒 ');
        }
      } else {
        showErrorSnackbar('Gagal😪', 'Username dan password salah..😒 ');
      }
    } catch (e) {
      handleError(e);
    }
    return null;
  }

  void showErrorSnackbar(String title, String message) {
    CustomHelperFunctions.stopLoading();
    SnackbarLoader.errorSnackBar(title: title, message: message);
  }

  void handleError(dynamic e) {
    print('Terjadi kesalahan saat mencoba login: $e');
    showErrorSnackbar('Error☠️', e.toString());
  }
}
