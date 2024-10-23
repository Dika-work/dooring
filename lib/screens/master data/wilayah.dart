import 'package:dooring/utils/constant/custom_size.dart';
import 'package:dooring/utils/popups/dialogs.dart';
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
              controller.namaWilayahController.text = model.wilayah;
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
                    TextFormField(
                      controller: controller.namaWilayahController,
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
                        controller.namaWilayahController.text = value;
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
                                    vertical: CustomSize.md)),
                            child: const Text('Close')),
                        ElevatedButton(
                          onPressed: () {
                            controller.editWilayah(model.idWilayah,
                                controller.namaWilayahController.text);
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
    CustomDialogs.defaultDialog(
      context: context,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tambah Wilayah',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: CustomSize.sm),
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
                          horizontal: CustomSize.lg, vertical: CustomSize.md)),
                  child: const Text('Close')),
              ElevatedButton(
                onPressed: () {
                  print('nambah data wilayah');
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomSize.lg, vertical: CustomSize.md)),
                child: const Text('Tambahkan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
