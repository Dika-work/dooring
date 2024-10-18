import 'package:dooring/screens/login.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/lps.png',
            width: CustomHelperFunctions.screenWidth() * .7,
            height: CustomHelperFunctions.screenHeight() * .45,
          ),
          Text(
            'PT. LANGGENG PRANAMAS SENTOSA',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: CustomSize.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.lg),
            child: Text(
              'Perusahaan JASA yang bergerak dalam bidang Angkutan Transportasi penggiriman barang ke luar Pulau, terutama Pulau KALIMANTAN & SULAWESI melalui Kapal Countainer',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Spacer(),
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
                await Navigator.pushReplacement(
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
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
