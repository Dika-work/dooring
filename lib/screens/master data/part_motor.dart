import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dooring/utils/constant/custom_size.dart';
import 'package:dooring/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/kapal_controller.dart';
import '../../helpers/connectivity.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/master data/part_motor_source.dart';

class PartMotor extends GetView<PartMotorController> {
  const PartMotor({super.key});

  @override
  Widget build(BuildContext context) {
    final networkConn = Get.find<NetworkManager>();
    final RxBool hasFetchedData = false.obs;

    // Menggunakan stream untuk mendengarkan perubahan koneksi
    networkConn.connectionStream.listen((result) {
      if (result == ConnectivityResult.none) {
        SnackbarLoader.errorSnackBar(
          title: 'Tidak ada internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia',
        );
      }
    });

    // Cek koneksi internet ketika pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await networkConn.isConnected()) {
        SnackbarLoader.errorSnackBar(
          title: 'Tidak ada internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia',
        );
        return;
      }

      if (!hasFetchedData.value) {
        await controller.fetchWilayahData();
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
          'Master Part',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Jika sedang loading
        if (controller.isLoading.value && controller.partMotorModel.isEmpty) {
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
                    await controller.fetchWilayahData();
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

        // Jika ada koneksi, tampilkan table grid
        final dataSource = PartMotorSource(
          onEdited: (PartMotorModel model) {
            controller.partMotorController.text = model.namaPart;
            showDialogWithAnimation(context);
          },
          partMotorModel: controller.partMotorModel,
        );

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchWilayahData();
          },
          child: SfDataGrid(
            source: dataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.both,
            verticalScrollController: controller.scrollController,
            headerGridLinesVisibility: GridLinesVisibility.both,
            horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Nama Part',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Nama Part',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              GridColumn(
                width: 80,
                columnName: 'Edit',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Edit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
                label: const Text('Tambah Part'),
              )
            : const SizedBox.shrink();
      }),
    );
  }

  void showDialogWithAnimation(BuildContext context) {
    CustomDialogs.defaultDialog(
      context: context,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tambah Part',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: CustomSize.sm),
          TextFormField(
            controller: controller.partMotorController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama part harus di isi';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Nama part motor',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.addPartMotor(controller.partMotorController.text);
                },
                child: const Text('Tambahkan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
