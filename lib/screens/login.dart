import 'dart:ui';

import 'package:dooring/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/login_controller.dart';
import '../utils/constant/custom_size.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rippleAnimation;

  final controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_login.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5),
            child: Container(
              color: Colors.transparent,
            ),
          )),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: CustomSize.lg),
                padding: const EdgeInsets.all(CustomSize.sm),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: CustomSize.xl),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username harus di isi';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.user),
                                labelText: 'Username',
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Obx(
                              () => TextFormField(
                                controller: controller.passwordController,
                                obscureText: controller.hidePassword.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password harus di isi';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => controller.hidePassword
                                        .value = !controller.hidePassword.value,
                                    icon: Icon(
                                      controller.hidePassword.value
                                          ? Iconsax.eye
                                          : Iconsax.eye_slash,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(
                                      () => SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: controller.rememberMe.value,
                                          onChanged: (value) =>
                                              controller.rememberMe.value =
                                                  !controller.rememberMe.value,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Ingat Saya',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  String? redirectRoute =
                                      Get.arguments?['redirectRoute'];

                                  controller.emailAndPasswordSignIn(
                                      redirectRoute: redirectRoute);
                                },
                                child: const Text('Masuk'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Center(
                  child: Transform.scale(
                    scale: _rippleAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
