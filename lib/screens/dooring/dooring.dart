import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/dooring_controller.dart';
import '../../controllers/dooring/kapal_controller.dart';
import '../../helpers/helper_func.dart';
import '../../models/dooring/defect_model.dart';
import '../../models/dooring/dooring_model.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/dooring/defect_source.dart';
import '../../utils/source/dooring/dooring_source.dart';
import '../../utils/theme/app_colors.dart';

class Dooring extends GetView<DooringController> {
  const Dooring({super.key});

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'No': 50,
      'Tgl Input': 100,
      'Nama Pelayaran': 150,
      'ETD': 100,
      'Tgl Bongkar': 100,
      'Total Unit': 80,
      'Lihat': 80,
      'Defect': 80,
      'Edit': 80,
    };
    final typeMotorController = Get.put(TypeMotorController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text('Data Dooring',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.dooringModel.isEmpty) {
          return const CustomCircularLoader();
        } else {
          final dataSource = DooringSource(
            onLihat: (DooringModel model) {
              print('ini lihat dooring');
            },
            onDefect: (DooringModel model) async {
              await Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TambahDefect(
                  model: model,
                  controller: typeMotorController,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return FadeTransition(
                    opacity: animation.drive(tween),
                    child: child,
                  );
                },
              ));
            },
            onEdited: (DooringModel model) {
              showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) {
                  return EditDooring(
                    model: model,
                    controller: controller,
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
            dooringModel: controller.dooringModel,
          );
          return SfDataGrid(
              source: dataSource,
              frozenColumnsCount: 2,
              columnWidthMode: ColumnWidthMode.auto,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columns: [
                GridColumn(
                    width: columnWidths['No']!,
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
                        ))),
                GridColumn(
                    width: columnWidths['Tgl Input']!,
                    columnName: 'Tgl Input',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Tgl Input',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Nama Pelayaran']!,
                    columnName: 'Nama Pelayaran',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Nama Pelayaran',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['ETD']!,
                    columnName: 'ETD',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'ETD',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Tgl Bongkar']!,
                    columnName: 'Tgl Bongkar',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Tgl Bongkar',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Total Unit']!,
                    columnName: 'Total Unit',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Total Unit',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Lihat']!,
                    columnName: 'Lihat',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Lihat',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Defect']!,
                    columnName: 'Defect',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Defect',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    width: columnWidths['Edit']!,
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
                        ))),
              ]);
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        onPressed: () async {
          await Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const TambahDooring(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = 0.0;
              const end = 1.0;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return FadeTransition(
                opacity: animation.drive(tween),
                child: child,
              );
            },
          ));
        },
        icon: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
        label: Text('Tambah Dooring',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.apply(color: AppColors.white)),
      ),
    );
  }
}

class TambahDooring extends StatelessWidget {
  const TambahDooring({super.key});

  @override
  Widget build(BuildContext context) {
    final kapalController = Get.put(KapalController());
    final wilayahController = Get.put(WilayahController());
    final controller = Get.put(DooringController());

    return Scaffold(
        appBar: AppBar(
          title: Text('Tambah Data Dooring',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Form(
          key: controller.dooringKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: CustomSize.md, vertical: CustomSize.sm),
            children: [
              Obx(() {
                return DropdownSearch<KapalModel>(
                  items: kapalController.filteredKapalModel,
                  itemAsString: (KapalModel kendaraan) => kendaraan.namaKapal,
                  selectedItem: kapalController.selectedKapal.value.isNotEmpty
                      ? kapalController.filteredKapalModel.firstWhere(
                          (kendaraan) =>
                              kendaraan.namaKapal ==
                              kapalController.selectedKapal.value,
                          orElse: () => KapalModel(
                            idPelayaran: 0,
                            namaKapal: '',
                            namaPelayaran: '',
                          ),
                        )
                      : null,
                  dropdownBuilder: (context, KapalModel? selectedItem) {
                    return Text(
                      selectedItem != null
                          ? selectedItem.namaKapal
                          : 'Pilih nama kapal',
                      style: TextStyle(
                          fontSize: CustomSize.fontSizeSm,
                          color:
                              selectedItem == null ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.w600),
                    );
                  },
                  onChanged: (KapalModel? kendaraan) {
                    if (kendaraan != null) {
                      kapalController.selectedKapal.value = kendaraan.namaKapal;
                      print(
                          'ini nama kapal : ${kapalController.selectedKapal.value}');
                    } else {
                      kapalController.resetSelectedKendaraan();
                    }
                  },
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Cari nama kapal...',
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => TextFormField(
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              DateTime? selectedDate =
                                  DateTime.tryParse(controller.tglETD.value);
                              showDatePicker(
                                context: context,
                                locale: const Locale("id", "ID"),
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(1850),
                                lastDate: DateTime(2040),
                              ).then((newSelectedDate) {
                                if (newSelectedDate != null) {
                                  controller.tglETD.value =
                                      CustomHelperFunctions
                                          .getFormattedDateDatabase(
                                              newSelectedDate);
                                  print(
                                      'Ini tanggal yang dipilih : ${controller.tglETD.value}');
                                }
                              });
                            },
                            icon: const Icon(Icons.calendar_today),
                          ),
                          hintText: controller.tglETD.value.isNotEmpty
                              ? DateFormat('d/M/yyyy').format(
                                  DateTime.tryParse(
                                          '${controller.tglETD.value} 00:00:00') ??
                                      DateTime.now(),
                                )
                              : 'ETD',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => TextFormField(
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              DateTime? selectedDate = DateTime.tryParse(
                                  controller.tglBongkar.value);
                              showDatePicker(
                                context: context,
                                locale: const Locale("id", "ID"),
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(1850),
                                lastDate: DateTime(2040),
                              ).then((newSelectedDate) {
                                if (newSelectedDate != null) {
                                  controller.tglBongkar.value =
                                      CustomHelperFunctions
                                          .getFormattedDateDatabase(
                                              newSelectedDate);
                                  print(
                                      'Ini tanggal yang dipilih : ${controller.tglBongkar.value}');
                                }
                              });
                            },
                            icon: const Icon(Icons.calendar_today),
                          ),
                          hintText: controller.tglBongkar.value.isNotEmpty
                              ? DateFormat('d/M/yyyy').format(
                                  DateTime.tryParse(
                                          '${controller.tglBongkar.value} 00:00:00') ??
                                      DateTime.now(),
                                )
                              : 'Tgl Bongkar',
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.jumlahUnitController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah Unit harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Unit',
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: Obx(() {
                      return DropdownSearch<WilayahModel>(
                        items: wilayahController.filteredWilayahModel,
                        itemAsString: (WilayahModel kendaraan) =>
                            kendaraan.wilayah,
                        selectedItem: wilayahController
                                .selectedWilayah.value.isNotEmpty
                            ? wilayahController.filteredWilayahModel.firstWhere(
                                (kendaraan) =>
                                    kendaraan.wilayah ==
                                    wilayahController.selectedWilayah.value,
                                orElse: () => WilayahModel(
                                  idWilayah: 0,
                                  wilayah: '',
                                ),
                              )
                            : null,
                        dropdownBuilder: (context, WilayahModel? selectedItem) {
                          return Text(
                            selectedItem != null
                                ? selectedItem.wilayah
                                : 'Wilayah',
                            style: TextStyle(
                                fontSize: CustomSize.fontSizeSm,
                                color: selectedItem == null
                                    ? Colors.grey
                                    : Colors.black,
                                fontWeight: FontWeight.w600),
                          );
                        },
                        onChanged: (WilayahModel? kendaraan) {
                          if (kendaraan != null) {
                            wilayahController.selectedWilayah.value =
                                kendaraan.wilayah;
                            print(
                                'ini nama kapal : ${wilayahController.selectedWilayah.value}');
                          } else {
                            wilayahController.resetSelectedKendaraan();
                          }
                        },
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search Kendaraan...',
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Center(
                child: Text(
                  'Serah Terima KSU Kelebihan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.helmController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Helm harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Helm',
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.accuController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Accu harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Accu',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.spionController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Spion harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Spion',
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.buserController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Buser harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Buser',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              TextFormField(
                controller: controller.toolsetController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Toolset harus di isi';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Toolset Kelebihan',
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Center(
                child: Text(
                  'Serah Terima KSU Kekurangan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.helmKurangController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Helm harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Helm',
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.accuKurangController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Accu harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Accu',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.spionKurangController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Spion harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Spion',
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.buserKurangController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Buser harus di isi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Buser',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              TextFormField(
                controller: controller.toolsetKurangController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Toolset harus di isi';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Toolset Kekurangan',
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwSections),
              SizedBox(
                width: CustomHelperFunctions.screenWidth(),
                child: ElevatedButton(
                    onPressed: () => controller.addDataDooring(),
                    child: const Text(
                      'Tambah',
                    )),
              )
            ],
          ),
        ));
  }
}

class TambahDefect extends StatelessWidget {
  const TambahDefect(
      {super.key, required this.model, required this.controller});

  final DooringModel model;
  final TypeMotorController controller;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.fetchDefetchTable(model.idDooring);
      },
    );

    final partMotorController = Get.put(PartMotorController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Defect Motor',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Form(
          key: controller.addDefectKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: CustomSize.md, vertical: CustomSize.sm),
            children: [
              const Text('Nama Kapal'),
              TextFormField(
                controller: TextEditingController(text: model.namaKapal),
                readOnly: true,
                decoration: const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('ETD'),
              TextFormField(
                controller: TextEditingController(
                    text: CustomHelperFunctions.getFormattedDate(
                        DateTime.parse(model.etd))),
                readOnly: true,
                decoration: const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('Tanggal Bongkar'),
              TextFormField(
                controller: TextEditingController(
                    text: CustomHelperFunctions.getFormattedDate(
                        DateTime.parse(model.tglBongkar))),
                readOnly: true,
                decoration: const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('Total Unit'),
              TextFormField(
                controller: TextEditingController(text: model.unit.toString()),
                readOnly: true,
                decoration: const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Obx(() {
                if (controller.isLoading.value &&
                    controller.defectModel.isEmpty) {
                  return const CustomCircularLoader();
                } else {
                  final dataSource = DefectSource(
                    onDeleted: (DefectModel modelDefect) =>
                        controller.deleteDefectTable(
                            modelDefect.idDooring, modelDefect.idDefect),
                    defectModel: controller.defectModel,
                    startIndex: 0 * 5,
                  );

                  final bool isTableEmpty = controller.defectModel.isEmpty;
                  final rowCount = controller.defectModel.length;

                  double gridHeight = 50.0 + (55.0 * 5);

                  final double tableHeight = isTableEmpty
                      ? 110
                      : 50.0 + (55.0 * rowCount).clamp(0, gridHeight - 55.0);

                  return Column(
                    children: [
                      SizedBox(
                        height: tableHeight,
                        child: SfDataGrid(
                          source: dataSource,
                          columnWidthMode: ColumnWidthMode.fill,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          horizontalScrollPhysics:
                              const NeverScrollableScrollPhysics(),
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
                                      ?.copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            GridColumn(
                              width: 100,
                              columnName: 'Part Motor',
                              label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Part Motor',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Jml',
                              label: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.lightBlue.shade100,
                                ),
                                child: Text(
                                  'Jml',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            if (controller.defectModel.isNotEmpty)
                              GridColumn(
                                columnName: 'Hps',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Hps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (rowCount > 5)
                        SfDataPager(
                          delegate: dataSource,
                          pageCount: (controller.defectModel.length / 5)
                              .ceilToDouble(),
                          direction: Axis.horizontal,
                        ),
                    ],
                  );
                }
              }),
              const SizedBox(height: CustomSize.spaceBtwItems),
              Obx(() {
                return DropdownSearch<TypeMotorModel>(
                  items: controller.filteredMotorModel,
                  itemAsString: (TypeMotorModel kendaraan) =>
                      kendaraan.typeMotor,
                  selectedItem: controller.selectedMotor.value.isNotEmpty
                      ? controller.filteredMotorModel.firstWhere(
                          (kendaraan) =>
                              kendaraan.typeMotor ==
                              controller.selectedMotor.value,
                          orElse: () => TypeMotorModel(
                            idType: 0,
                            merk: '',
                            typeMotor: '',
                          ),
                        )
                      : null,
                  dropdownBuilder: (context, TypeMotorModel? selectedItem) {
                    return Text(
                      selectedItem != null
                          ? selectedItem.typeMotor
                          : 'Pilih type motor',
                      style: TextStyle(
                          fontSize: CustomSize.fontSizeSm,
                          color:
                              selectedItem == null ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.w600),
                    );
                  },
                  onChanged: (TypeMotorModel? kendaraan) {
                    if (kendaraan != null) {
                      controller.selectedMotor.value = kendaraan.typeMotor;
                      print(
                          'ini nama kapal : ${controller.selectedMotor.value}');
                    } else {
                      controller.resetSelectedKendaraan();
                    }
                  },
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search Type Motor...',
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: CustomSize.sm),
              Obx(() {
                return DropdownSearch<PartMotorModel>(
                  items: partMotorController.filteredPartMotorModel,
                  itemAsString: (PartMotorModel kendaraan) =>
                      kendaraan.namaPart,
                  selectedItem: partMotorController
                          .selectedWilayah.value.isNotEmpty
                      ? partMotorController.filteredPartMotorModel.firstWhere(
                          (kendaraan) =>
                              kendaraan.namaPart ==
                              partMotorController.selectedWilayah.value,
                          orElse: () => PartMotorModel(
                            idPart: 0,
                            namaPart: '',
                          ),
                        )
                      : null,
                  dropdownBuilder: (context, PartMotorModel? selectedItem) {
                    return Text(
                      selectedItem != null
                          ? selectedItem.namaPart
                          : 'Pilih part motor',
                      style: TextStyle(
                          fontSize: CustomSize.fontSizeSm,
                          color:
                              selectedItem == null ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.w600),
                    );
                  },
                  onChanged: (PartMotorModel? kendaraan) {
                    if (kendaraan != null) {
                      partMotorController.selectedWilayah.value =
                          kendaraan.namaPart;
                      print(
                          'ini nama kapal : ${partMotorController.selectedWilayah.value}');
                    } else {
                      partMotorController.resetSelectedKendaraan();
                    }
                  },
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search part motor...',
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: CustomSize.sm),
              const Text('Jumlah'),
              TextFormField(
                controller: controller.jumlahDefectController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: CustomSize.spaceBtwSections),
              SizedBox(
                width: CustomHelperFunctions.screenWidth(),
                child: Obx(() {
                  return Row(
                    children: [
                      if (controller
                          .defectModel.isNotEmpty) // Cek jika data ada
                        Expanded(
                          flex: 2, // Tombol selesai flex 2
                          child: OutlinedButton(
                            onPressed: () =>
                                controller.selesaiDefect(model.idDooring),
                            style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: AppColors.success)),
                            child: const Text(
                              'Selesai',
                            ),
                          ),
                        ),
                      if (controller.defectModel.isNotEmpty)
                        const SizedBox(
                            width: CustomSize.sm), // Jarak antar tombol
                      Expanded(
                        flex: controller.defectModel.isNotEmpty
                            ? 1
                            : 3, // Tombol tambah flex 1 jika ada data, flex 3 jika tidak ada
                        child: ElevatedButton(
                          onPressed: () => controller.addDataDefect(
                            model.idDooring,
                            CustomHelperFunctions.formattedTime,
                            CustomHelperFunctions.getFormattedDateDatabase(
                                DateTime.now()),
                            controller.selectedMotor.value,
                            partMotorController.selectedWilayah.value,
                            int.parse(controller.jumlahDefectController.text),
                          ),
                          // onPressed: () {
                          //   print('ini id dooring: ${model.idDooring}');
                          //   print(
                          //       'ini jam dooring: ${CustomHelperFunctions.formattedTime}');
                          //   print(
                          //       'ini tgl dooring: ${CustomHelperFunctions.getFormattedDateDatabase(DateTime.now())}');
                          //   print(
                          //       'ini typeMotor dooring: ${controller.selectedMotor.value}');
                          //   print(
                          //       'ini part dooring: ${partMotorController.selectedWilayah.value}');
                          //   print(
                          //       'ini jumlah dooring: ${int.parse(controller.jumlahDefectController.text)}');
                          // },
                          child: const Text(
                            'Tambah',
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          )),
    );
  }
}

class EditDooring extends StatefulWidget {
  const EditDooring({super.key, required this.controller, required this.model});

  final DooringController controller;
  final DooringModel model;

  @override
  State<EditDooring> createState() => _EditDooringState();
}

class _EditDooringState extends State<EditDooring> {
  late int idDooring;
  late String namaKapal;
  late String wilayah;
  late String etd;
  late String tglBongkar;
  late TextEditingController unit;
  late TextEditingController helm1;
  late TextEditingController accu1;
  late TextEditingController spion1;
  late TextEditingController buser1;
  late TextEditingController toolset1;
  late TextEditingController helmKurang;
  late TextEditingController accuKurang;
  late TextEditingController spionKurang;
  late TextEditingController buserKurang;
  late TextEditingController toolsetKurang;

  @override
  void initState() {
    super.initState();
    idDooring = widget.model.idDooring;
    namaKapal = widget.model.namaKapal;
    wilayah = widget.model.wilayah;
    etd = widget.model.etd;
    tglBongkar = widget.model.tglBongkar;
    unit = TextEditingController(text: widget.model.unit.toString());
    helm1 = TextEditingController(text: widget.model.helm1.toString());
    accu1 = TextEditingController(text: widget.model.accu1.toString());
    spion1 = TextEditingController(text: widget.model.spion1.toString());
    buser1 = TextEditingController(text: widget.model.buser1.toString());
    toolset1 = TextEditingController(text: widget.model.toolset1.toString());
    helmKurang =
        TextEditingController(text: widget.model.helmKurang.toString());
    accuKurang =
        TextEditingController(text: widget.model.accuKurang.toString());
    spionKurang =
        TextEditingController(text: widget.model.spionKurang.toString());
    buserKurang =
        TextEditingController(text: widget.model.buserKurang.toString());
    toolsetKurang =
        TextEditingController(text: widget.model.totalsetKurang.toString());
  }

  @override
  void dispose() {
    unit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kapalController = Get.put(KapalController());
    final wilayahController = Get.put(WilayahController());
    return AlertDialog(
      title: Text(
        'Edit data DO Global',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama Kapal'),
            Obx(() {
              return DropdownSearch<KapalModel>(
                items: kapalController.filteredKapalModel,
                itemAsString: (KapalModel kendaraan) => kendaraan.namaKapal,
                selectedItem: kapalController.filteredKapalModel.firstWhere(
                  (kendaraan) => kendaraan.namaKapal == namaKapal,
                  orElse: () => KapalModel(
                    idPelayaran: 0,
                    namaKapal: '',
                    namaPelayaran: '',
                  ),
                ),
                dropdownBuilder: (context, KapalModel? selectedItem) {
                  return Text(
                    selectedItem != null
                        ? selectedItem.namaKapal
                        : 'Pilih nama kapal',
                    style: TextStyle(
                      fontSize: CustomSize.fontSizeSm,
                      color: selectedItem == null ? Colors.grey : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
                onChanged: (KapalModel? kendaraan) {
                  setState(() {
                    if (kendaraan != null) {
                      namaKapal = kendaraan.namaKapal;
                      kapalController.selectedKapal.value = kendaraan.namaKapal;
                    } else {
                      kapalController.resetSelectedKendaraan();
                      namaKapal = '';
                    }
                  });
                },
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search Kapal...',
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('ETD'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    DateTime? selectedDate = DateTime.tryParse(etd);
                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1850),
                      lastDate: DateTime(2040),
                    ).then((newSelectedDate) {
                      if (newSelectedDate != null) {
                        etd = CustomHelperFunctions.getFormattedDateDatabase(
                            newSelectedDate);
                        print('Ini tanggal yang dipilih : $etd');
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
                hintText: etd.isNotEmpty
                    ? DateFormat('d/M/yyyy').format(
                        DateTime.tryParse('$etd 00:00:00') ?? DateTime.now(),
                      )
                    : 'ETD',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Tgl Bongkar'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    DateTime? selectedDate = DateTime.tryParse(tglBongkar);
                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1850),
                      lastDate: DateTime(2040),
                    ).then((newSelectedDate) {
                      if (newSelectedDate != null) {
                        tglBongkar =
                            CustomHelperFunctions.getFormattedDateDatabase(
                                newSelectedDate);
                        print('Ini tanggal yang dipilih : $tglBongkar');
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
                hintText: tglBongkar.isNotEmpty
                    ? DateFormat('d/M/yyyy').format(
                        DateTime.tryParse('$tglBongkar 00:00:00') ??
                            DateTime.now(),
                      )
                    : 'Tanggal Bongkar',
              ),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Jumlah Unit'),
            TextFormField(
              controller: unit,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  unit.text = value;
                });
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Wilayah'),
            Obx(() {
              return DropdownSearch<WilayahModel>(
                items: wilayahController.filteredWilayahModel,
                itemAsString: (WilayahModel wilayahItem) => wilayahItem.wilayah,
                selectedItem: wilayah.isNotEmpty
                    ? wilayahController.filteredWilayahModel.firstWhere(
                        (wilayahItem) => wilayahItem.wilayah == wilayah,
                        orElse: () => WilayahModel(
                          idWilayah: 0,
                          wilayah: '',
                        ),
                      )
                    : null,
                dropdownBuilder: (context, WilayahModel? selectedItem) {
                  return Text(
                    selectedItem != null ? selectedItem.wilayah : 'Wilayah',
                    style: TextStyle(
                      fontSize: CustomSize.fontSizeSm,
                      color: selectedItem == null ? Colors.grey : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
                onChanged: (WilayahModel? wilayahItem) {
                  setState(() {
                    if (wilayahItem != null) {
                      wilayah = wilayahItem.wilayah;
                      wilayahController.selectedWilayah.value =
                          wilayahItem.wilayah;
                    } else {
                      wilayahController.resetSelectedKendaraan();
                      wilayah = '';
                    }
                  });
                },
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Cari wilayah...',
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('KSU KELEBIHAN',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.apply(color: AppColors.success)),
                      const SizedBox(height: CustomSize.md),
                      TextFormField(
                        controller: helm1,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Helm')),
                        onChanged: (value) {
                          setState(() {
                            helm1.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: accu1,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Accu')),
                        onChanged: (value) {
                          setState(() {
                            accu1.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: spion1,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Spion')),
                        onChanged: (value) {
                          setState(() {
                            spion1.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: buser1,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Buser')),
                        onChanged: (value) {
                          setState(() {
                            buser1.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: toolset1,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(label: Text('ToolSet')),
                        onChanged: (value) {
                          setState(() {
                            toolset1.text = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: CustomSize.md),
                Expanded(
                  child: Column(
                    children: [
                      Text('KSU KURANG',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.apply(color: AppColors.error)),
                      const SizedBox(height: CustomSize.md),
                      TextFormField(
                        controller: helmKurang,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Helm')),
                        onChanged: (value) {
                          setState(() {
                            helmKurang.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: accuKurang,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Accu')),
                        onChanged: (value) {
                          setState(() {
                            accuKurang.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: spionKurang,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Spion')),
                        onChanged: (value) {
                          setState(() {
                            spionKurang.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: buserKurang,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(label: Text('Buser')),
                        onChanged: (value) {
                          setState(() {
                            buserKurang.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: CustomSize.sm),
                      TextFormField(
                        controller: toolsetKurang,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(label: Text('ToolSet')),
                        onChanged: (value) {
                          setState(() {
                            toolsetKurang.text = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        TextButton(
          // onPressed: () {
          //   print('ini id dooring $idDooring');
          //   print('ini nama kapal nya :$namaKapal');
          //   print('ini wilayahnya :$wilayah');
          //   print('ini etd nya :$etd');
          //   print('ini tanggal bongkarnya :$tglBongkar');
          //   print('ini jumlah unitnya :${int.parse(unit.text)}');
          //   print('ini helm nya: ${int.parse(helm1.text)}');
          //   print('ini accu nya: ${int.parse(accu1.text)}');
          //   print('ini spion nya :${int.parse(spion1.text)}');
          //   print('ini buser nya :${int.parse(buser1.text)}');
          //   print('ini toolset nya :${int.parse(toolset1.text)}');
          //   print('ini hlm kurang :${int.parse(helmKurang.text)}');
          //   print('ini accu kurang :${int.parse(accuKurang.text)}');
          //   print('ini spion kurang :${int.parse(spionKurang.text)}');
          //   print('ini buser kurang: ${int.parse(buserKurang.text)}');
          //   print('ini toolset kurang: ${int.parse(toolsetKurang.text)}');
          // },
          onPressed: () => widget.controller.editDooring(
            idDooring,
            namaKapal,
            wilayah,
            etd,
            tglBongkar,
            int.parse(unit.text),
            int.parse(helm1.text),
            int.parse(accu1.text),
            int.parse(spion1.text),
            int.parse(buser1.text),
            int.parse(toolset1.text),
            int.parse(helmKurang.text),
            int.parse(accuKurang.text),
            int.parse(spionKurang.text),
            int.parse(buserKurang.text),
            int.parse(toolsetKurang.text),
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
