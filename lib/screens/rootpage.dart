import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/login_controller.dart';
import '../utils/constant/custom_size.dart';
import '../utils/constant/storage_util.dart';
import '../utils/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        leading: IconButton(
          icon: const Icon(Iconsax.firstline),
          onPressed: () {
            storageUtil.scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: CustomSize.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.dark,
            ),
            child: IconButton(
                onPressed: () => storageUtil.logout(),
                icon: const Icon(
                  Iconsax.logout_1,
                  color: AppColors.white,
                  size: CustomSize.iconMd,
                )),
          ),
        ],
      ),
      drawer: CustomDrawer(
          onItemTapped: storageUtil.onItemTapped,
          selectedIndex: storageUtil.selectedIndex.value,
          logout: storageUtil.logout,
          closeDrawer: () =>
              storageUtil.scaffoldKey.currentState!.closeDrawer()),
      key: storageUtil.scaffoldKey,
      body: Center(
        child: storageUtil.widgetOptions
            .elementAt(storageUtil.selectedIndex.value),
      ),
    );
  }
}
