import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/login_controller.dart';
import '../../models/user_model.dart';
import '../../screens/homepage.dart';
import '../popups/snackbar.dart';

class StorageUtil {
  final prefs = GetStorage();
  final baseURL = 'http://langgeng.dyndns.biz/Dooring/Api';

  UserModel? getUserDetails() {
    final data = prefs.read('user');
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  void saveUserDetails(UserModel user) {
    prefs.write('user', user.toJson());
  }

  void logout() {
    final loginController = Get.find<LoginController>();
    loginController.resetFormKey(); // Reset GlobalKey untuk form

    prefs.remove('user');
    prefs.remove('userToken');

    Get.offAllNamed('/login'); // Arahkan kembali ke halaman login

    SnackbarLoader.successSnackBar(
        title: 'Logged Out', message: 'Anda telah berhasil keluar 👍');
  }

  final selectedIndex = 0.obs;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> widgetOptions = <Widget>[
    const Homepage(),
  ];

  onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
