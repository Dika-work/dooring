import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/kapal_controller.dart';
import '../../helpers/connectivity.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/master data/pelayaran_source.dart';

class MasterPelayaran extends GetView<PelayaranController> {
  const MasterPelayaran({super.key});

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
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text('Master Pelayaran',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Obx(() {
        // Jika sedang loading
        if (controller.isLoading.value && controller.pelayaranModel.isEmpty) {
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

        // Jika ada koneksi, tampilkan tabel
        final dataSource = PelayaranSource(
          onEdited: (PelayaranModel model) {
            controller.namaPelayaran.text = model.namaPel;
            CustomDialogs.defaultDialog(
              context: context,
              contentWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text('Edit Nama Pelayaran',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  const Divider(),
                  const SizedBox(height: CustomSize.sm),
                  Form(
                    key: controller.addPartKey,
                    child: TextFormField(
                      controller: controller.namaPelayaran,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama pelayaran harus diisi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Nama Pelayaran'),
                      ),
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
                                  horizontal: CustomSize.lg,
                                  vertical: CustomSize.md)),
                          child: const Text('Close')),
                      ElevatedButton(
                        onPressed: () {
                          controller.editPart(
                              model.idPelayaran, controller.namaPelayaran.text);
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: CustomSize.lg,
                                vertical: CustomSize.md)),
                        child: const Text('Tambahkan'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          onDeleted: (PelayaranModel model) => CustomDialogs.deleteDialog(
              context: context,
              onConfirm: () => controller.deletePelayaran(model.idPelayaran)),
          kapalModel: controller.pelayaranModel,
        );

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchWilayahData();
          },
          child: SfDataGrid(
            source: dataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
            columns: [
              GridColumn(
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
                columnName: 'Nama Pelayaran',
                width: 130,
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Nama Pelayaran',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              GridColumn(
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
              GridColumn(
                columnName: 'Hapus',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Hapus',
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
        return (networkConn.connectionStatus != ConnectivityResult.none)
            ? FloatingActionButton.extended(
                backgroundColor: const Color(0xff03dac6),
                foregroundColor: Colors.black,
                onPressed: () {
                  CustomDialogs.defaultDialog(
                    context: context,
                    contentWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text('Tambah Pelayaran',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                        const Divider(),
                        const SizedBox(height: CustomSize.sm),
                        Form(
                          key: controller.addPartKey,
                          child: TextFormField(
                            controller: controller.namaPelayaran,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama pelayaran harus di isi';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                label: Text('Nama Pelayaran')),
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
                                      horizontal: CustomSize.lg,
                                      vertical: CustomSize.md)),
                              child: const Text('Close'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.addPartMotor(
                                    controller.namaPelayaran.text);
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: CustomSize.lg,
                                      vertical: CustomSize.md)),
                              child: const Text('Tambahkan'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Kapal'),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}
