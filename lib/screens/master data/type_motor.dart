import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dooring/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/kapal_controller.dart';
import '../../helpers/connectivity.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/master data/type_motor_source.dart';
import '../../widgets/dropdown.dart';

class MasterTypeMotor extends GetView<TypeMotorController> {
  const MasterTypeMotor({super.key});

  @override
  Widget build(BuildContext context) {
    final networkConn = Get.find<NetworkManager>();
    final RxBool hasFetchedData = false.obs;

    // Cek koneksi internet saat pertama kali layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await networkConn.isConnected()) {
        SnackbarLoader.errorSnackBar(
          title: 'Tidak ada internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia',
        );
        return;
      }

      if (!hasFetchedData.value) {
        await controller.fetchTypeMotor();
        hasFetchedData.value = true;
      }
    });

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            'Master Type Motor',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.typeMotorModel.isEmpty) {
            return const CustomCircularLoader();
          }

          // Jika tidak ada koneksi
          if (networkConn.connectionStatus == ConnectivityResult.none) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomAnimationLoaderWidget(
                  text:
                      'Koneksi internet terputus\nsilakan tekan tombol refresh untuk mencoba kembali.',
                  animation: 'assets/animations/404.json',
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () async {
                    if (await networkConn.isConnected()) {
                      await controller.fetchTypeMotor();
                    } else {
                      SnackbarLoader.errorSnackBar(
                        title: 'Tidak ada internet',
                        message: 'Silahkan coba lagi setelah koneksi tersedia',
                      );
                    }
                  },
                  child: const Text('Refresh'),
                ),
              ],
            );
          }

          final dataSource = TypeMotorSource(
            onEdited: (TypeMotorModel model) {
              controller.merk.value = model.merk.toUpperCase();
              controller.namaTypeMotorController.text = model.typeMotor;
              CustomDialogs.defaultDialog(
                context: context,
                contentWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Type Motor',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: CustomSize.sm),
                    Obx(() {
                      return DropDownWidget(
                        value: controller.merk.value,
                        items: controller.merkList,
                        onChanged: (String? value) {
                          if (value != null) {
                            controller.merk.value = value;
                          }
                        },
                      );
                    }),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    TextFormField(
                      controller: controller.namaTypeMotorController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Type motor harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Type motor',
                      ),
                      onChanged: (value) {
                        controller.namaTypeMotorController.text = value;
                      },
                    ),
                    const SizedBox(height: CustomSize.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: CustomSize.lg,
                                vertical: CustomSize.md),
                          ),
                          child: const Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.editTypeMotor(
                              model.idType,
                              controller.merk.value,
                              controller.namaTypeMotorController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: CustomSize.lg,
                                vertical: CustomSize.md),
                          ),
                          child: const Text('Tambahkan'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            onDeleted: (TypeMotorModel model) => CustomDialogs.deleteDialog(
              context: context,
              onConfirm: () {
                controller.hapusTypeMotor(model.idType);
              },
            ),
            typeMotorModel: controller.displayedData,
            context: context,
          );
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchTypeMotor();
            },
            child: SfDataGrid(
              source: dataSource,
              columnWidthMode: ColumnWidthMode.fill,
              verticalScrollController: controller.scrollController,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columns: [
                GridColumn(
                  width: 50,
                  columnName: 'No',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'No',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Merk',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'Merk',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridColumn(
                  width: 120,
                  columnName: 'Type Motor',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'Type Motor',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridColumn(
                  width: 60,
                  columnName: 'Edit',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'Edit',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridColumn(
                  width: 60,
                  columnName: 'Hapus',
                  label: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.lightBlue.shade100,
                    ),
                    child: Text(
                      'Hapus',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        floatingActionButton: Obx(() {
          return (networkConn.connectionStatus != ConnectivityResult.none &&
                  controller.isFabVisible.value)
              ? FloatingActionButton.extended(
                  backgroundColor: const Color(0xff03dac6),
                  foregroundColor: Colors.black,
                  onPressed: () {
                    showDialogWithAnimation(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Motor'),
                )
              : const SizedBox.shrink();
        }));
  }

  void showDialogWithAnimation(BuildContext context) {
    CustomDialogs.defaultDialog(
      context: context,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tambah Motor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: CustomSize.sm),
          Obx(() {
            return DropDownWidget(
              value: controller.merk.value,
              items: controller.merkList,
              onChanged: (String? value) {
                controller.merk.value = value!;
              },
            );
          }),
          const SizedBox(height: CustomSize.spaceBtwItems),
          TextFormField(
            controller: controller.namaTypeMotorController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Type motor harus di isi';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Type motor',
            ),
          ),
          const SizedBox(height: CustomSize.spaceBtwSections),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomSize.lg, vertical: CustomSize.md),
                ),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('nambah data wilayah');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomSize.lg, vertical: CustomSize.md),
                ),
                child: const Text('Tambahkan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
