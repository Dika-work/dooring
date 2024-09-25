import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/constant/storage_util.dart';

class CustomHelperFunctions {
  final storageUtil = StorageUtil();
  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  //  void Function? navigateToRootPage() {
  //   Navigator.of(Get.overlayContext!).pop();
  //   storageUtil.scaffoldKey.currentState!.closeDrawer();
  // }

  // memotong teks yang terlalu panjang sehingga tidak melebihi panjang maksimum yang ditentukan
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  // static bool isDarkMode(BuildContext context) {
  //   return Theme.of(context).brightness == Brightness.dark;
  // }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String getFormattedDateDatabase(DateTime date,
      {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  // camel case
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    // Split by space and process each word separately
    List<String> words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        // Convert the first character to uppercase and concatenate with the rest of the word
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(' ');
  }

  // jam hari ini
  static String get formattedTime => DateFormat.Hms().format(DateTime.now());

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
