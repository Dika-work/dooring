import 'package:cached_network_image/cached_network_image.dart';
import 'package:dooring/helpers/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constant/custom_size.dart';
import '../utils/constant/storage_util.dart';
import '../utils/loader/shimmer.dart';
import '../utils/theme/app_colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final user = storageUtil.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title:
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: CustomSize.md,
                horizontal: CustomSize.sm,
              ),
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                      width: CustomSize.profileImageSize,
                      height: CustomSize.profileImageSize,
                      imageUrl: user!.gambar,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (_, __, ___) =>
                          const CustomShimmerEffect(
                        width: 55,
                        height: 55,
                        radius: 55,
                      ),
                      errorWidget: (_, __, ___) =>
                          Image.asset('assets/images/person.png'),
                    ),
                  ),
                ),
                Container(
                  width: CustomHelperFunctions.screenWidth(),
                  margin: const EdgeInsets.only(top: CustomSize.spaceBtwItems),
                  padding: const EdgeInsets.all(CustomSize.sm),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.black, width: 1),
                      bottom: BorderSide(color: AppColors.black, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nama Lengkap'),
                      Text(user.nama),
                    ],
                  ),
                ),
                Container(
                  width: CustomHelperFunctions.screenWidth(),
                  padding: const EdgeInsets.all(CustomSize.sm),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.black, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jabatan'),
                      Text(user.tipe),
                    ],
                  ),
                ),
                const SizedBox(height: CustomSize.md),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Edit Profil'),
                ),
                const SizedBox(height: CustomSize.sm),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Ubah Password'),
                ),
                Container(
                  width: CustomHelperFunctions.screenWidth(),
                  margin: const EdgeInsets.only(top: CustomSize.spaceBtwItems),
                  padding: const EdgeInsets.symmetric(
                    vertical: CustomSize.sm,
                    horizontal: CustomSize.md,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data User'),
                      Divider(),
                      Text('Alamat'),
                      Divider(),
                      Text('Catatan'),
                      Text(
                        'Fitur ini Masih dikembangkan, harap tunggu update selanjutnya',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
                bottom: CustomSize.md), // Menambahkan padding bawah
            child: Center(
              child: Text('@Langgeng Pranamas Sentosa'),
            ),
          ),
        ],
      ),
    );
  }
}
