import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/detail_defect_controller.dart';
import '../../controllers/dooring/dooring_controller.dart';
import '../../controllers/dooring/kapal_controller.dart';
import '../../helpers/helper_func.dart';
import '../../models/dooring/defect_model.dart';
import '../../models/dooring/dooring_model.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/dooring/defect_source.dart';
import '../../utils/source/dooring/lihat_defect_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';
import '../dooring/tambah_defect_detail.dart';

class TambahAllDooring extends StatelessWidget {
  const TambahAllDooring({super.key});

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
            onPressed: () {
              controller.jumlahUnitController.clear();
              controller.helmController.clear();
              controller.accuController.clear();
              controller.spionController.clear();
              controller.buserController.clear();
              controller.toolsetController.clear();
              controller.helmKurangController.clear();
              controller.accuKurangController.clear();
              controller.spionKurangController.clear();
              controller.buserKurangController.clear();
              controller.toolsetKurangController.clear();
              Get.back();
            },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ETD'),
                        Obx(
                          () => TextFormField(
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  DateTime? selectedDate = DateTime.tryParse(
                                      controller.tglETD.value);
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
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tgl Bongkar'),
                        Obx(
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
                        )
                      ],
                    ),
                  ),
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

class TambahAllDefect extends StatelessWidget {
  const TambahAllDefect(
      {super.key, required this.model, required this.controller});

  final AllDooringModel model;
  final TypeMotorController controller;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.fetchDefetchTable(model.idDooring);
      },
    );

    final partMotorController = Get.put(PartMotorController());
    final detailDefectController = Get.put(DetailDefectController());

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CustomSize.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    onEdited: (DefectModel modelDefect) {
                      controller.editJumlahDefectController.text =
                          modelDefect.jumlah.toString();
                      CustomDialogs.defaultDialog(
                          context: context,
                          contentWidget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Edit Data Defect',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                              const SizedBox(height: CustomSize.spaceBtwItems),
                              Obx(() {
                                return DropdownSearch<TypeMotorModel>(
                                  items: controller.filteredMotorModel,
                                  itemAsString: (TypeMotorModel kendaraan) =>
                                      kendaraan.typeMotor,
                                  selectedItem:
                                      controller.filteredMotorModel.isNotEmpty
                                          ? controller.filteredMotorModel
                                              .firstWhere(
                                              (kendaraan) =>
                                                  kendaraan.typeMotor ==
                                                  modelDefect.typeMotor,
                                              orElse: () => TypeMotorModel(
                                                idType: 0,
                                                merk: '',
                                                typeMotor: '',
                                              ),
                                            )
                                          : null,
                                  dropdownBuilder:
                                      (context, TypeMotorModel? selectedItem) {
                                    return Text(
                                      selectedItem != null
                                          ? selectedItem.typeMotor
                                          : 'Pilih type motor',
                                      style: TextStyle(
                                        fontSize: CustomSize.fontSizeSm,
                                        color: selectedItem == null
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                  onChanged: (TypeMotorModel? kendaraan) {
                                    if (kendaraan != null) {
                                      controller.selectedMotor.value =
                                          kendaraan.typeMotor;
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
                                  items: partMotorController
                                      .filteredPartMotorModel,
                                  itemAsString: (PartMotorModel kendaraan) =>
                                      kendaraan.namaPart,
                                  selectedItem: partMotorController
                                          .filteredPartMotorModel.isNotEmpty
                                      ? partMotorController
                                          .filteredPartMotorModel
                                          .firstWhere(
                                          (kendaraan) =>
                                              kendaraan.namaPart ==
                                              modelDefect.part,
                                          orElse: () => PartMotorModel(
                                            idPart: 0,
                                            namaPart: '',
                                          ),
                                        )
                                      : null,
                                  dropdownBuilder:
                                      (context, PartMotorModel? selectedItem) {
                                    return Text(
                                      selectedItem != null
                                          ? selectedItem.namaPart
                                          : 'Pilih part motor',
                                      style: TextStyle(
                                        fontSize: CustomSize.fontSizeSm,
                                        color: selectedItem == null
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                  onChanged: (PartMotorModel? kendaraan) {
                                    if (kendaraan != null) {
                                      partMotorController.selectedWilayah
                                          .value = kendaraan.namaPart;
                                      print(
                                          'ini nama kapal : ${partMotorController.selectedWilayah.value}');
                                    } else {
                                      partMotorController
                                          .resetSelectedKendaraan();
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
                              const SizedBox(height: 10),
                              TextFormField(
                                controller:
                                    controller.editJumlahDefectController,
                                decoration: const InputDecoration(
                                    label: Text('Jumlah')),
                                onChanged: (value) {
                                  controller.editJumlahDefectController.text =
                                      value;
                                },
                              ),
                              const SizedBox(
                                  height: CustomSize.spaceBtwSections),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      // print(
                                      //     'ini id defect: ${modelDefect.idDefect}');
                                      // print(
                                      //     'ini id dooring: ${modelDefect.idDooring}');
                                      // print(
                                      //     'ini type motor yg di pilih: ${controller.selectedMotor.value}');
                                      // print(
                                      //     'ini part yg dipilih: ${partMotorController.selectedWilayah.value}');
                                      // print(
                                      //     'ini jumlah yang di masukkan ${controller.editJumlahDefectController.text}');
                                      controller.editDataDefect(
                                          modelDefect.idDefect,
                                          modelDefect.idDooring,
                                          controller.selectedMotor.value,
                                          partMotorController
                                              .selectedWilayah.value,
                                          controller
                                              .editJumlahDefectController.text);
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
                          ));
                    },
                    onAdded: (DefectModel modelDefect) {
                      // Get.to(() =>
                      //     TambahDefectDetail(idDefect: modelDefect.idDefect));
                    },
                    onDeleted: (DefectModel modelDefect) =>
                        CustomDialogs.deleteDialog(
                            context: context,
                            onConfirm: () =>
                                detailDefectController.deleteDefectTable(
                                    modelDefect.idDefect,
                                    modelDefect.idDooring)),
                    onLihat: (DefectModel modelDefect) {
                      detailDefectController
                          .fetchDetailDefect(modelDefect.idDefect);
                      CustomDialogs.defaultDialog(
                          context: context,
                          contentWidget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Detail Rincian Defect',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                              const SizedBox(height: CustomSize.spaceBtwItems),
                              TextFormField(
                                controller: TextEditingController(
                                    text: modelDefect.typeMotor),
                                decoration: const InputDecoration(
                                    label: Text('Type Motor')),
                              ),
                              const SizedBox(height: CustomSize.sm),
                              TextFormField(
                                controller: TextEditingController(
                                    text: modelDefect.part),
                                decoration: const InputDecoration(
                                    label: Text('Part Motor')),
                              ),
                              const SizedBox(height: CustomSize.sm),
                              TextFormField(
                                controller: TextEditingController(
                                    text: modelDefect.jumlah.toString()),
                                decoration: const InputDecoration(
                                    label: Text('Jumlah')),
                              ),
                              const SizedBox(height: CustomSize.defaultSpace),
                              Obx(() {
                                if (detailDefectController.isLoading.value &&
                                    detailDefectController
                                        .detailModel.isEmpty) {
                                  return const CustomCircularLoader();
                                } else {
                                  final dataSource = LihatDefectSource(
                                      detailDefectModel:
                                          detailDefectController.detailModel);

                                  final bool isTableEmpty =
                                      detailDefectController
                                          .detailModel.isEmpty;
                                  final rowCount =
                                      detailDefectController.detailModel.length;

                                  double gridHeight = 50.0 + (55.0 * 5);

                                  final double tableHeight = isTableEmpty
                                      ? 110
                                      : 50.0 +
                                          (55.0 * rowCount)
                                              .clamp(0, gridHeight - 55.0);

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: tableHeight,
                                        child: SfDataGrid(
                                            source: dataSource,
                                            columnWidthMode:
                                                ColumnWidthMode.fill,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            verticalScrollPhysics:
                                                const NeverScrollableScrollPhysics(),
                                            columns: [
                                              GridColumn(
                                                columnName: 'No',
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    color: Colors
                                                        .lightBlue.shade100,
                                                  ),
                                                  child: Text(
                                                    'No',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'No Mesin',
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    color: Colors
                                                        .lightBlue.shade100,
                                                  ),
                                                  child: Text(
                                                    'No Mesin',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'No Rangka',
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    color: Colors
                                                        .lightBlue.shade100,
                                                  ),
                                                  child: Text(
                                                    'No Rangka',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      if (rowCount >= 5)
                                        SfDataPager(
                                          delegate: dataSource,
                                          pageCount: (detailDefectController
                                                      .detailModel.length /
                                                  5)
                                              .ceilToDouble(),
                                          direction: Axis.horizontal,
                                        ),
                                    ],
                                  );
                                }
                              }),
                              const SizedBox(
                                  height: CustomSize.spaceBtwInputFields),
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: CustomSize.xl,
                                        vertical: CustomSize.md),
                                  ),
                                  child: const Text(
                                    'Close',
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
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
                          verticalScrollPhysics:
                              const NeverScrollableScrollPhysics(),
                          columnWidthMode: isTableEmpty
                              ? ColumnWidthMode.fill
                              : ColumnWidthMode.auto,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
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
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            if (controller.defectModel.isNotEmpty)
                              GridColumn(
                                columnName: 'Add',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.lightBlue.shade100,
                                  ),
                                  child: Text(
                                    'Add',
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
              Form(
                key: controller.addDefectKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        dropdownBuilder:
                            (context, TypeMotorModel? selectedItem) {
                          return Text(
                            selectedItem != null
                                ? selectedItem.typeMotor
                                : 'Pilih type motor',
                            style: TextStyle(
                                fontSize: CustomSize.fontSizeSm,
                                color: selectedItem == null
                                    ? Colors.grey
                                    : Colors.black,
                                fontWeight: FontWeight.w600),
                          );
                        },
                        onChanged: (TypeMotorModel? kendaraan) {
                          if (kendaraan != null) {
                            controller.selectedMotor.value =
                                kendaraan.typeMotor;
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
                            ? partMotorController.filteredPartMotorModel
                                .firstWhere(
                                (kendaraan) =>
                                    kendaraan.namaPart ==
                                    partMotorController.selectedWilayah.value,
                                orElse: () => PartMotorModel(
                                  idPart: 0,
                                  namaPart: '',
                                ),
                              )
                            : null,
                        dropdownBuilder:
                            (context, PartMotorModel? selectedItem) {
                          return Text(
                            selectedItem != null
                                ? selectedItem.namaPart
                                : 'Pilih part motor',
                            style: TextStyle(
                                fontSize: CustomSize.fontSizeSm,
                                color: selectedItem == null
                                    ? Colors.grey
                                    : Colors.black,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Data tidak boleh kosong!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    Obx(() {
                      bool checkStDetail = controller.defectModel
                          .any((element) => element.status == 0);

                      return Row(
                        children: [
                          Expanded(
                            flex: 2, // Tombol selesai flex 2
                            child: OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: AppColors.success)),
                              child: const Text(
                                'Kembali',
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: CustomSize.sm), // Jarak antar tombol
                          Expanded(
                            flex:
                                1, // Tombol tambah flex 1 jika ada data, flex 3 jika tidak ada
                            child: ElevatedButton(
                              onPressed: () {
                                if (!controller.addDefectKey.currentState!
                                        .validate() ||
                                    controller.selectedMotor.value.isEmpty ||
                                    partMotorController
                                        .selectedWilayah.value.isEmpty) {
                                  SnackbarLoader.warningSnackBar(
                                      title: 'Oops 🤣',
                                      message:
                                          'Harap mengisi seluruh form yang ada');
                                  return;
                                }
                                controller.addDataDefect(
                                  model.idDooring,
                                  CustomHelperFunctions.formattedTime,
                                  CustomHelperFunctions
                                      .getFormattedDateDatabase(DateTime.now()),
                                  controller.selectedMotor.value,
                                  partMotorController.selectedWilayah.value,
                                  int.parse(controller
                                      .jumlahDefectController.text
                                      .trim()),
                                );
                              },
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
                          if (controller.defectModel.isNotEmpty &&
                              !checkStDetail)
                            const SizedBox(width: CustomSize.sm),
                          Visibility(
                              visible: controller.defectModel.isNotEmpty &&
                                  !checkStDetail,
                              child: Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                    onPressed: () {
                                      CustomDialogs.konfirmasiDialog(
                                        context: context,
                                        onConfirm: () => controller
                                            .selesaiDefect(model.idDooring),
                                      );
                                    },
                                    child: const Text('Selesai')),
                              ))
                        ],
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditAllDooring extends StatefulWidget {
  const EditAllDooring(
      {super.key, required this.controller, required this.model});

  final DooringController controller;
  final AllDooringModel model;

  @override
  State<EditAllDooring> createState() => _EditAllDooringState();
}

class _EditAllDooringState extends State<EditAllDooring> {
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
    helm1.dispose();
    accu1.dispose();
    spion1.dispose();
    buser1.dispose();
    toolset1.dispose();
    helmKurang.dispose();
    accuKurang.dispose();
    spionKurang.dispose();
    buserKurang.dispose();
    toolsetKurang.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kapalController = Get.put(KapalController());
    final wilayahController = Get.put(WilayahController());
    return SingleChildScrollView(
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
          Text('Status Defect', style: Theme.of(context).textTheme.labelMedium),
          Obx(
            () => DropDownWidget(
              value: widget.controller.statusEditDefect.value,
              items: widget.controller.listStatusEditDefect.keys.toList(),
              onChanged: (String? value) {
                widget.controller.statusEditDefect.value = value!;
                print(
                    'ini pilihan status defect nya : ${widget.controller.getEditStatusDefect}');
              },
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      decoration: const InputDecoration(label: Text('ToolSet')),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      decoration: const InputDecoration(label: Text('ToolSet')),
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
          ),
          const SizedBox(height: CustomSize.spaceBtwSections),
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
                  widget.controller.editDooring(
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
                      int.parse(toolsetKurang.text));
                  print('ini idDooring nya : $idDooring');
                  print('ini namaKapal nya : $namaKapal');
                  print('ini wilayah nya : $wilayah');
                  print('ini etd nya : $etd');
                  print('ini tglBongkar nya : $tglBongkar');
                  print('ini tglBongkar nya : ${int.parse(unit.text)}');
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
