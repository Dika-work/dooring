import 'package:dooring/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../helpers/helper_func.dart';
import '../utils/constant/custom_size.dart';
import '../utils/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/welcome.json',
              width: CustomHelperFunctions.screenWidth() * .7,
              height: CustomHelperFunctions.screenHeight() * .45,
            ),
            Text(
              'Selamat Datang',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: CustomSize.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.lg),
              child: Text(
                'Aplikasi praktis untuk layanan antar-jemput langsung dari pintu Anda, mudah dan aman dalam genggaman',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.xl),
              child: SwipeableButtonView(
                onWaitingProcess: () {
                  Future.delayed(
                      const Duration(seconds: 2),
                      () => setState(() {
                            isFinished = true;
                          }));
                },
                isFinished: isFinished,
                onFinish: () async {
                  await Navigator.push(
                      context,
                      PageTransition(
                          child: const LoginScreen(),
                          type: PageTransitionType.fade));
                  setState(() {
                    isFinished = false;
                  });
                },
                activeColor: AppColors.primary,
                buttonWidget: const Icon(Icons.keyboard_arrow_right_rounded,
                    color: AppColors.black),
                buttonText: 'Slide to Next',
                buttontextstyle: const TextStyle(
                    fontSize: CustomSize.fontSizeLg, color: AppColors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
