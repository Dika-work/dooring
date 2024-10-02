import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/constant/custom_size.dart';
import '../utils/constant/storage_util.dart';
import '../utils/loader/shimmer.dart';
import '../utils/theme/app_colors.dart';
import 'expandable_container.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.logout,
    required this.closeDrawer,
  });

  final Function(int) onItemTapped;
  final int selectedIndex;
  final Function logout;
  final void Function()? closeDrawer;

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final user = storageUtil.getUserDetails();
    return Drawer(
      backgroundColor: AppColors.lightExpandable,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: CustomSize.imageCarouselHeight,
              padding: const EdgeInsets.only(top: CustomSize.lg),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_login.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(CustomSize.xl),
                    child: CachedNetworkImage(
                      width: 70,
                      height: 70,
                      imageUrl: user!.gambar,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (_, __, ___) =>
                          const CustomShimmerEffect(
                        width: 55,
                        height: 55,
                        radius: 55,
                      ),
                      errorWidget: (_, ___, __) =>
                          Image.asset('assets/icons/person.png'),
                    ),
                  ),
                  Text(
                    user.nama.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.white),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: CustomSize.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(CustomSize.sm),
                            color: AppColors.dark,
                          ),
                          child: IconButton(
                              onPressed: () => Get.toNamed('/profile'),
                              icon: const Icon(
                                Iconsax.user,
                                color: AppColors.white,
                              )),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(CustomSize.sm),
                            color: AppColors.dark,
                          ),
                          child: IconButton(
                              onPressed: closeDrawer,
                              icon: const Icon(
                                Iconsax.back_square,
                                color: AppColors.white,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ExpandableContainer(
                icon: Iconsax.book, textTitle: 'Home', onTap: closeDrawer),
            user.menu1 == 1
                ? ExpandableContainer(
                    icon: Iconsax.folder_2,
                    textTitle: 'Master Data',
                    content: Column(
                      children: [
                        ListTile(
                          onTap: () => Get.toNamed('/master-kapal'),
                          leading: const Icon(
                            Iconsax.record,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'Kapal',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.toNamed('/master-pelayaran'),
                          leading: const Icon(
                            Iconsax.record,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'Pelayaran',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.toNamed('/master-part'),
                          leading: const Icon(
                            Iconsax.record,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'Part',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.toNamed('/master-motor'),
                          leading: const Icon(
                            Iconsax.record,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'Type Motor',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.toNamed('/master-wilayah'),
                          leading: const Icon(
                            Iconsax.record,
                            color: AppColors.darkExpandableContent,
                          ),
                          title: Text(
                            'Wilayah',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.light),
                          ),
                        ),
                      ],
                    ))
                : const SizedBox.shrink(),
            ExpandableContainer(
              icon: Iconsax.document_cloud,
              textTitle: 'Semua Data',
              content: ListTile(
                onTap: () {},
                leading: const Icon(
                  Iconsax.record,
                  color: AppColors.darkExpandableContent,
                ),
                title: Text(
                  'Tambah Data',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.light),
                ),
              ),
            ),
            ExpandableContainer(
              icon: Iconsax.add,
              textTitle: 'Dooring',
              content: ListTile(
                onTap: () => Get.toNamed('/data-dooring'),
                leading: const Icon(
                  Iconsax.record,
                  color: AppColors.darkExpandableContent,
                ),
                title: Text(
                  'Tambah Data',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.light),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
