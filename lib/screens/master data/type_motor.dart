import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/kapal_controller.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/master data/type_motor_source.dart';
import '../../widgets/dropdown.dart';

class MasterTypeMotor extends GetView<TypeMotorController> {
  const MasterTypeMotor({super.key});

  @override
  Widget build(BuildContext context) {
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
        } else {
          final dataSource = TypeMotorSource(
            onEdited: (TypeMotorModel model) {
              controller.merk.value = model.merk.toUpperCase();
              controller.namaTypeMotorController.text = model.typeMotor;
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
                          borderRadius:
                              BorderRadius.circular(CustomSize.borderRadiusLg),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Edit Type Motor',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              return DropDownWidget(
                                value: controller.merk.value,
                                items: controller.merkList,
                                onChanged: (String? value) {
                                  if (value != null) {
                                    controller.merk.value = value;
                                    print(
                                        'Ini type motor yang dipilih: ${controller.merk.value}');
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
                                            vertical: CustomSize.md)),
                                    child: const Text('Close')),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.editTypeMotor(
                                        model.idType,
                                        controller.merk.value,
                                        controller
                                            .namaTypeMotorController.text);
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
            },
            onDeleted: (TypeMotorModel model) =>
                controller.hapusTypeMotor(model.idType),
            typeMotorModel: controller.displayedData,
          );

          return Column(
            children: [
              Expanded(
                child: SfDataGrid(
                  source: dataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  verticalScrollController: controller.scrollController,
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller
                  .isLoadingMore.value) // Loader di bawah ketika lazy loading
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
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
        label: const Text('Tambah Motor'),
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
                borderRadius: BorderRadius.circular(CustomSize.borderRadiusLg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tambah Motor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return DropDownWidget(
                      value: controller.merk.value,
                      items: controller.merkList,
                      onChanged: (String? value) {
                        controller.merk.value = value!;
                        print(
                            'ini type motor yg di pilih: ${controller.merk.value}');
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
