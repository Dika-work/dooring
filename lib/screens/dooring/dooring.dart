import 'package:dooring/utils/popups/snackbar.dart';
import 'package:dooring/widgets/dropdown.dart';
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
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/source/dooring/defect_source.dart';
import '../../utils/source/dooring/dooring_source.dart';
import '../../utils/source/dooring/lihat_defect_source.dart';
import '../../utils/theme/app_colors.dart';
import 'lihat_dooring.dart';
import 'tambah_defect_detail.dart';

class Dooring extends GetView<DooringController> {
  const Dooring({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.fetchDooringData();
      },
    );

    late Map<String, double> columnWidths = {
      'No': 50,
      if (controller.isAdmin) 'Wilayah': 70,
      'Tgl Input': 100,
      'Nama Pelayaran': 150,
      'ETD': 100,
      'Tgl Bongkar': 100,
      'Unit Bongkar': 100,
      if (controller.lihatRole != 0) 'Lihat': 80,
      if (controller.tambahRole != 0) 'Defect': 80,
      if (controller.editRole != 0) 'Edit': 80,
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
        } else if (controller.dooringModel.isEmpty) {
          return CustomAnimationLoaderWidget(
            text: 'Tidak ada data saat ini',
            animation: 'assets/animations/404.json',
            height: CustomHelperFunctions.screenHeight() * 0.4,
            width: CustomHelperFunctions.screenHeight(),
          );
        } else {
          final dataSource = DooringSource(
            isAdmin: controller.isAdmin,
            onLihat: (DooringModel model) {
              Get.to(() => LihatDooring(model: model));
            },
            onDefect: (DooringModel model) async {
              if (model.statusDefect == 0) {
                CustomDialogs.defaultDialog(
                  contentWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('Konfirmasi Defect Motor',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      const Divider(),
                      const SizedBox(height: CustomSize.sm),
                      Text('Nama Kapal',
                          style: Theme.of(context).textTheme.labelMedium),
                      TextFormField(
                        controller:
                            TextEditingController(text: model.namaKapal),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tanggal Bongkar',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller: TextEditingController(
                                    text: model.tglBongkar),
                                readOnly: true,
                              ),
                            ],
                          )),
                          const SizedBox(width: CustomSize.sm),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ETD',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller:
                                    TextEditingController(text: model.etd),
                                readOnly: true,
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: CustomSize.sm),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jumlah Unit',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller: TextEditingController(
                                    text: model.unit.toString()),
                                readOnly: true,
                              ),
                            ],
                          )),
                          const SizedBox(width: CustomSize.sm),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Wilayah',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller:
                                    TextEditingController(text: model.wilayah),
                                readOnly: true,
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: CustomSize.sm),
                      Text('Status Defect',
                          style: Theme.of(context).textTheme.labelMedium),
                      Obx(
                        () => DropDownWidget(
                          value: controller.statusDefect.value,
                          items: controller.listStatusDefect.keys.toList(),
                          onChanged: (String? value) {
                            controller.statusDefect.value = value!;
                          },
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
                              if (controller.statusDefect.value ==
                                  'Pilih Kondisi Defect') {
                                // Tampilkan Snackbar jika nilai masih default
                                SnackbarLoader.errorSnackBar(
                                  title: 'Error',
                                  message:
                                      'Silakan pilih kondisi defect terlebih dahulu.',
                                );
                              } else {
                                // Lanjutkan jika sudah memilih kondisi defect
                                controller.changeStatusDefect(model.idDooring,
                                    controller.getStatusDefect);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: CustomSize.lg,
                                vertical: CustomSize.md,
                              ),
                            ),
                            child: const Text('Tambahkan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  context: context,
                );
              } else if (model.statusDefect == 1) {
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
              }
            },
            onEdited: (DooringModel model) {
              CustomDialogs.defaultDialog(
                  context: context,
                  margin: const EdgeInsets.symmetric(vertical: CustomSize.xl),
                  contentWidget: EditDooring(
                    model: model,
                    controller: controller,
                  ));
            },
            dooringModel: controller.dooringModel,
          );
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchDooringData();
            },
            child: SfDataGrid(
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
                  if (controller.isAdmin)
                    GridColumn(
                        width: columnWidths['Wilayah']!,
                        columnName: 'Wilayah',
                        label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Wilayah',
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
                      width: columnWidths['Unit Bongkar']!,
                      columnName: 'Unit Bongkar',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Unit Bongkar',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  if (controller.lihatRole != 0)
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
                  if (controller.tambahRole != 0)
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
                  if (controller.editRole != 0)
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
                ]),
          );
        }
      }),
    );
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
      body: ListView(
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
          const SizedBox(height: CustomSize.sm),
          Obx(() {
            if (controller.isLoading.value && controller.defectModel.isEmpty) {
              return const CustomCircularLoader();
            } else {
              final dataSource = DefectSource(
                // Your edited onEdited code with the validation for jumlahInput
                onEdited: (DefectModel modelDefect) {
                  // Set default jumlah from modelDefect
                  controller.editJumlahDefectController.text =
                      modelDefect.jumlah.toString();

                  // Assuming jumlahInput is already fetched and stored in DetailDefectController
                  final int jumlahInput =
                      detailDefectController.jumlahInput.value;

                  // Variables to store the selected values
                  TypeMotorModel? selectedMotor =
                      controller.filteredMotorModel.firstWhere(
                    (kendaraan) => kendaraan.typeMotor == modelDefect.typeMotor,
                    orElse: () =>
                        TypeMotorModel(idType: 0, merk: '', typeMotor: ''),
                  );

                  PartMotorModel? selectedPart =
                      partMotorController.filteredPartMotorModel.firstWhere(
                    (part) => part.namaPart == modelDefect.part,
                    orElse: () => PartMotorModel(idPart: 0, namaPart: ''),
                  );

                  CustomDialogs.defaultDialog(
                    context: context,
                    contentWidget: Form(
                      key: detailDefectController.detailDefectKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Edit Data Defect',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const Divider(),
                          const SizedBox(height: CustomSize.sm),
                          // Dropdown for selecting Type Motor
                          DropdownSearch<TypeMotorModel>(
                            items: controller.filteredMotorModel,
                            itemAsString: (TypeMotorModel kendaraan) =>
                                kendaraan.typeMotor,
                            selectedItem: selectedMotor,
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
                              selectedMotor = kendaraan;
                            },
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                    hintText: 'Search Type Motor...'),
                              ),
                            ),
                          ),

                          const SizedBox(height: CustomSize.sm),

                          // Dropdown for selecting Part Motor
                          DropdownSearch<PartMotorModel>(
                            items: partMotorController.filteredPartMotorModel,
                            itemAsString: (PartMotorModel part) =>
                                part.namaPart,
                            selectedItem: selectedPart,
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
                            onChanged: (PartMotorModel? part) {
                              selectedPart = part;
                            },
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                    hintText: 'Search part motor...'),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Input for jumlah with validation
                          TextFormField(
                            controller: controller.editJumlahDefectController,
                            decoration:
                                const InputDecoration(label: Text('Jumlah')),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jumlah tidak boleh kosong';
                              }
                              int? inputJumlah = int.tryParse(value);
                              if (inputJumlah == null) {
                                return 'Jumlah harus berupa angka';
                              }
                              if (inputJumlah < jumlahInput) {
                                return 'Jumlah tidak boleh kurang dari $jumlahInput';
                              }
                              return null; // Valid
                            },
                            onChanged: (value) {
                              controller.editJumlahDefectController.text =
                                  value;
                            },
                          ),

                          const SizedBox(height: CustomSize.spaceBtwSections),

                          // Action buttons
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
                                  // Validate inputs
                                  if (selectedMotor != null &&
                                      selectedPart != null &&
                                      detailDefectController
                                          .detailDefectKey.currentState!
                                          .validate()) {
                                    controller.editDataDefect(
                                      modelDefect.idDefect,
                                      modelDefect.idDooring,
                                      selectedMotor!.typeMotor,
                                      selectedPart!.namaPart,
                                      controller
                                          .editJumlahDefectController.text,
                                    );
                                  } else {
                                    SnackbarLoader.errorSnackBar(
                                        title: 'Oops',
                                        message:
                                            'Jumlah tidak boleh kurang dari jumpah input sebelumnya');
                                  }
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
                    ),
                  );
                },

                onAdded: (DefectModel modelDefect) {
                  Get.to(
                      () => TambahDefectDetail(idDefect: modelDefect.idDefect));
                },
                onDeleted: (DefectModel modelDefect) =>
                    CustomDialogs.deleteDialog(
                        context: context,
                        onConfirm: () =>
                            detailDefectController.deleteDefectTable(
                                modelDefect.idDefect, modelDefect.idDooring)),
                onLihat: (DefectModel modelDefect) {
                  detailDefectController
                      .fetchDetailDefect(modelDefect.idDefect);
                  CustomDialogs.defaultDialog(
                      context: context,
                      contentWidget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Detail Rincian Defect',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const Divider(),
                          const SizedBox(height: CustomSize.sm),
                          TextFormField(
                            controller: TextEditingController(
                                text: modelDefect.typeMotor),
                            decoration: const InputDecoration(
                                label: Text('Type Motor')),
                          ),
                          const SizedBox(height: CustomSize.sm),
                          TextFormField(
                            controller:
                                TextEditingController(text: modelDefect.part),
                            decoration: const InputDecoration(
                                label: Text('Part Motor')),
                          ),
                          const SizedBox(height: CustomSize.sm),
                          TextFormField(
                            controller: TextEditingController(
                                text: modelDefect.jumlah.toString()),
                            decoration:
                                const InputDecoration(label: Text('Jumlah')),
                          ),
                          const SizedBox(height: CustomSize.defaultSpace),
                          Obx(() {
                            if (detailDefectController.isLoading.value &&
                                detailDefectController.detailModel.isEmpty) {
                              return const CustomCircularLoader();
                            } else {
                              final dataSource = LihatDefectSource(
                                  detailDefectModel:
                                      detailDefectController.detailModel);

                              final bool isTableEmpty =
                                  detailDefectController.detailModel.isEmpty;
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
                                        columnWidthMode: ColumnWidthMode.fill,
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
                                                color:
                                                    Colors.lightBlue.shade100,
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
                                                color:
                                                    Colors.lightBlue.shade100,
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
                                                color:
                                                    Colors.lightBlue.shade100,
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
                      pageCount:
                          (controller.defectModel.length / 5).ceilToDouble(),
                      direction: Axis.horizontal,
                    ),
                ],
              );
            }
          }),
          const SizedBox(height: CustomSize.sm),
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
                    dropdownBuilder: (context, TypeMotorModel? selectedItem) {
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
                              side: const BorderSide(color: AppColors.success)),
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
                              CustomHelperFunctions.getFormattedDateDatabase(
                                  DateTime.now()),
                              controller.selectedMotor.value,
                              partMotorController.selectedWilayah.value,
                              int.parse(controller.jumlahDefectController.text
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
                      if (controller.defectModel.isNotEmpty && !checkStDetail)
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
          ),
        ],
      ),
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
  late String atd;
  late String tglBongkar;
  late TextEditingController unit;
  late TextEditingController ct20;
  late TextEditingController ct40;
  late TextEditingController helm1;
  late TextEditingController accu1;
  late TextEditingController spion1;
  late TextEditingController buser1;
  late TextEditingController toolset1;

  @override
  void initState() {
    super.initState();
    idDooring = widget.model.idDooring;
    namaKapal = widget.model.namaKapal;
    wilayah = widget.model.wilayah;
    etd = widget.model.etd;
    atd = widget.model.atd;
    tglBongkar = widget.model.tglBongkar;
    ct20 = TextEditingController(text: widget.model.ct20);
    ct40 = TextEditingController(text: widget.model.ct40);
    tglBongkar = widget.model.tglBongkar;
    unit = TextEditingController(text: widget.model.unit.toString());
    helm1 = TextEditingController(text: widget.model.helm1.toString());
    accu1 = TextEditingController(text: widget.model.accu1.toString());
    spion1 = TextEditingController(text: widget.model.spion1.toString());
    buser1 = TextEditingController(text: widget.model.buser1.toString());
    toolset1 = TextEditingController(text: widget.model.toolset1.toString());
  }

  @override
  void dispose() {
    unit.dispose();
    helm1.dispose();
    accu1.dispose();
    spion1.dispose();
    buser1.dispose();
    toolset1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.dooringKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Edit Data Dooring',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const Divider(),
            const SizedBox(height: CustomSize.sm),
            const Text('Nama Kapal'),
            TextFormField(
              controller: TextEditingController(text: namaKapal),
              readOnly: true,
            ),
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
            const Text('ATD'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    DateTime? selectedDate = DateTime.tryParse(atd);
                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1850),
                      lastDate: DateTime(2040),
                    ).then((newSelectedDate) {
                      if (newSelectedDate != null) {
                        atd = CustomHelperFunctions.getFormattedDateDatabase(
                            newSelectedDate);
                        print('Ini tanggal yang dipilih : $atd');
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
            const Text('Wilayah'),
            TextFormField(
              controller: TextEditingController(text: wilayah),
              readOnly: true,
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
            const Text('Unit Bongkar'),
            TextFormField(
              controller: unit,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Pastikan text diubah dengan benar
                unit.text = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Total Motor harus diisi';
                }
                final inputValue = int.tryParse(value) ?? 0;

                final maxUnit = widget.model.unit;

                if (inputValue > maxUnit) {
                  return 'Jumlah unit tidak boleh melebihi $maxUnit unit';
                }
                return null;
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('CT 20"'),
            TextFormField(
              controller: ct20,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ct20.text = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'CT 20 harus diisi';
                }

                final inputValue = int.tryParse(value) ?? 0;
                final maxCt20 = int.tryParse(widget.model.ct20);

                if (inputValue > maxCt20!) {
                  return 'CT 20 tidak boleh melebihi $maxCt20';
                }
                return null;
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('CT 40"'),
            TextFormField(
              controller: ct40,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ct40.text = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'CT 40 harus diisi';
                }

                final inputValue = int.tryParse(value) ?? 0;
                final maxCt40 = int.tryParse(widget.model.ct40);

                if (inputValue > maxCt40!) {
                  return 'CT 40 tidak boleh melebihi $maxCt40';
                }
                return null;
              },
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Text('Status Defect',
                style: Theme.of(context).textTheme.labelMedium),
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
            Center(
              child: Text('ALAT - ALAT MOTOR',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.black)),
            ),
            const Divider(),
            const SizedBox(height: CustomSize.sm),
            const Text('Helm'),
            TextFormField(
              controller: helm1,
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Accu'),
            TextFormField(
              controller: accu1,
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Spion'),
            TextFormField(
              controller: spion1,
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Buser'),
            TextFormField(
              controller: buser1,
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('ToolSet'),
            TextFormField(
              controller: toolset1,
              readOnly: true,
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
                    widget.controller.editDooring(
                      idDooring,
                      namaKapal,
                      wilayah,
                      etd,
                      atd,
                      tglBongkar,
                      int.parse(unit.text),
                      ct20.text,
                      ct40.text,
                      int.parse(helm1.text),
                      int.parse(accu1.text),
                      int.parse(spion1.text),
                      int.parse(buser1.text),
                      int.parse(toolset1.text),
                    );
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
      ),
    );
  }
}
