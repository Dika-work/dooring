import 'package:flutter/material.dart';

import '../constant/custom_size.dart';
import 'app_colors.dart';

class CustomAppBarTheme {
  CustomAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    iconTheme:
        IconThemeData(color: AppColors.iconPrimary, size: CustomSize.iconMd),
    actionsIconTheme:
        IconThemeData(color: AppColors.iconPrimary, size: CustomSize.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        fontFamily: 'Urbanist'),
  );
}
