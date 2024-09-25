import 'package:dooring/utils/theme/app_colors.dart';
import 'package:dooring/utils/theme/appbar_theme.dart';
import 'package:dooring/utils/theme/bottom_sheet.dart';
import 'package:dooring/utils/theme/checkbox_theme.dart';
import 'package:dooring/utils/theme/elevated_btn_theme.dart';
import 'package:dooring/utils/theme/outlined_btn_theme.dart';
import 'package:dooring/utils/theme/text_field_theme.dart';
import 'package:dooring/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: AppColors.grey,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    textTheme: CustomTextTheme.lightTextTheme,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    checkboxTheme: CustomCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    bottomSheetTheme: CustomBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.lightInputDecorationTheme,
  );
}
