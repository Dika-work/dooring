import 'package:flutter/material.dart';

import '../../helpers/helper_func.dart';
import '../constant/custom_size.dart';
import '../theme/app_colors.dart';

class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({
    super.key,
    this.foregroundColor = AppColors.white,
    this.backgroundColor = AppColors.primary,
    this.size = 50.0,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CustomHelperFunctions.screenWidth(),
      height: CustomHelperFunctions.screenHeight(),
      child: Center(
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(CustomSize.sm),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: foregroundColor,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
