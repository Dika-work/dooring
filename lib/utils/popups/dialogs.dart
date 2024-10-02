import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/custom_size.dart';
import '../theme/app_colors.dart';
import 'loading_text.dart';

class CustomDialogs {
  static defaultDialog({
    required BuildContext context,
    required Widget contentWidget,
    EdgeInsetsGeometry? margin,
  }) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: margin,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(CustomSize.borderRadiusLg),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              child: contentWidget,
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
      },
    );
  }

  static deleteDialog({
    required BuildContext context,
    String title = 'Konfirmasi Penghapusan',
    String content =
        'Menghapus data ini akan menghapus semua data yang terkait. Apakah Anda yakin?',
    String cancelText = 'Batal',
    String confirmText = 'Hapus',
    Function()? onCancel,
    Function()? onConfirm,
  }) {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  static loadingIndicator() {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      barrierColor: Colors.transparent, // Set barrier color to transparent
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  padding:
                      const EdgeInsets.all(8.0), // Adjust padding if needed
                  decoration: const BoxDecoration(
                    color: AppColors
                        .primary, // Adjust color to match your primary color
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(
                    color: AppColors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              const LoadingText()
            ],
          ),
        );
      },
    );
  }
}
