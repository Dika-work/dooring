import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helpers/connectivity.dart';
import '../repository/login_repo.dart';
import '../utils/popups/dialogs.dart';
import '../utils/popups/snackbar.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final loginRepository = Get.put(LoginRepository());

  // Gunakan GlobalKey<FormState> untuk validasi form
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    // Inisialisasi data dari localStorage
    usernameController.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    passwordController.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose TextEditingController untuk menghindari kebocoran memori
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> emailAndPasswordSignIn({String? redirectRoute}) async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      SnackbarLoader.errorSnackBar(
          title: 'Tidak ada koneksi internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia');
      return;
    }

    // Validasi form menggunakan GlobalKey<FormState>
    if (loginFormKey.currentState != null &&
        !loginFormKey.currentState!.validate()) {
      return;
    }

    if (rememberMe.value) {
      // Simpan username dan password jika opsi "Ingat Saya" aktif
      localStorage.write('REMEMBER_ME_EMAIL', usernameController.text.trim());
      localStorage.write(
          'REMEMBER_ME_PASSWORD', passwordController.text.trim());
    }

    CustomDialogs.loadingIndicator();

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Oper rute tujuan jika ada
    await loginRepository.fetchUserDetails(username, password,
        redirectRoute: redirectRoute);
  }

  // Reset GlobalKey untuk menghindari duplikat setelah logout atau perubahan
  void resetFormKey() {
    loginFormKey = GlobalKey<FormState>();
  }
}
