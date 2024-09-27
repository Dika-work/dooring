import 'package:dooring/utils/constant/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/kapal_controller.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/master data/wilayah_source.dart';

class MasterWilayah extends GetView<WilayahController> {
  const MasterWilayah({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Master Wilayah',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.wilayahModel.isEmpty) {
          return const CustomCircularLoader();
        } else {
          final dataSource = WilayahSource(
            onEdited: (WilayahModel model) {
              print('ini edit master kapal');
            },
            wilayahModel: controller.wilayahModel,
          );

          return SfDataGrid(
            source: dataSource,
            columnWidthMode:
                ColumnWidthMode.fill, // Kolom akan mengisi seluruh lebar layar
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
                columnName: 'Nama Wilayah',
                label: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.lightBlue.shade100,
                  ),
                  child: Text(
                    'Nama Wilayah',
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
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          showDialogWithAnimation(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kapal'),
      ),
    );
  }

  void showDialogWithAnimation(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tambah Wilayah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.namaWilayahController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama wilayah harus di isi';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nama wilayah',
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          print('nambah data wilayah');
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
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
      },
    );
  }
}
