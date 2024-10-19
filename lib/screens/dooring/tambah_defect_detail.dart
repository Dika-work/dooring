import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/detail_defect_controller.dart';
import '../../models/dooring/detail_defect_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/source/dooring/detail_defect_source.dart';
import '../../utils/theme/app_colors.dart';

class TambahDefectDetail extends StatelessWidget {
  const TambahDefectDetail({super.key, required this.idDefect});

  final int idDefect;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailDefectController());
    final TextEditingController noMesinController = TextEditingController();
    final TextEditingController noRangkaController = TextEditingController();
    final TextEditingController noContainerController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.fetchDetailDefect(idDefect);
      },
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Defect Motor',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return const CustomCircularLoader();
            }

            if (controller.detailModel.isEmpty) {
              return const Center(
                child: Text('Data tidak ditemukan'),
              );
            }

            final model = controller.detailModel.first;

            return RefreshIndicator(
              onRefresh: () async => controller.fetchDetailDefect(idDefect),
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
                    controller: TextEditingController(text: model.etd),
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.sm),
                  const Text('Tgl Bongkar'),
                  TextFormField(
                    controller: TextEditingController(text: model.tglBongkar),
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.sm),
                  const Text('Total Unit'),
                  TextFormField(
                    controller:
                        TextEditingController(text: model.unit.toString()),
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.sm),
                  Center(
                      child: Text('PART MOTOR',
                          style: Theme.of(context).textTheme.titleMedium)),
                  const SizedBox(height: CustomSize.sm),
                  const Text('Type Motor'),
                  TextFormField(
                    controller:
                        TextEditingController(text: model.typeMotor.toString()),
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.sm),
                  const Text('Part Motor'),
                  TextFormField(
                    controller:
                        TextEditingController(text: model.part.toString()),
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.sm),
                  const Text('Jumlah Deffect'),
                  TextFormField(
                    controller:
                        TextEditingController(text: model.jumlah.toString()),
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.sm),
                  const Text('Jumlah Input'),
                  TextFormField(
                    controller: TextEditingController(
                        text: model.jumlahInput == 0
                            ? model.jumlahInput.toString()
                            : controller.jumlahInput.value.toString()),
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    decoration: const InputDecoration(
                        filled: true, fillColor: AppColors.buttonDisabled),
                  ),
                  const SizedBox(height: CustomSize.spaceBtwItems),
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.detailModel.isEmpty) {
                      return const CustomCircularLoader();
                    } else {
                      final dataSource = DetailDefectSource(
                        onEdited: (DetailDefectModel modelDetailDefect) {
                          noMesinController.text = modelDetailDefect.noMesin;
                          noRangkaController.text = modelDetailDefect.noRangka;
                          noContainerController.text = modelDetailDefect.noCT;
                          CustomDialogs.defaultDialog(
                            context: context,
                            contentWidget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Detail Data Defect',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                const SizedBox(
                                    height: CustomSize.spaceBtwItems),
                                TextFormField(
                                  controller: noContainerController,
                                  decoration: const InputDecoration(
                                      label: Text('No Container')),
                                  onChanged: (value) {
                                    noContainerController.text = value;
                                  },
                                ),
                                const SizedBox(height: CustomSize.sm),
                                TextFormField(
                                  controller: noMesinController,
                                  decoration: const InputDecoration(
                                      label: Text('No Mesin')),
                                  onChanged: (value) {
                                    noMesinController.text = value;
                                  },
                                ),
                                const SizedBox(height: CustomSize.sm),
                                TextFormField(
                                  controller: noRangkaController,
                                  decoration: const InputDecoration(
                                      label: Text('No Rangka')),
                                  onChanged: (value) {
                                    noRangkaController.text = value;
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
                                        controller.editDefectTable(
                                            modelDetailDefect.idDetail,
                                            modelDetailDefect.idDooring,
                                            modelDetailDefect.idDefect,
                                            noMesinController.text,
                                            noRangkaController.text,
                                            noContainerController.text);
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
                        onDeleted: (DetailDefectModel modelDetailDefect) {
                          controller.deleteDetailDefect(
                              modelDetailDefect.idDetail, idDefect);
                        },
                        detailDefectModel: controller.detailModel,
                        startIndex: 0 * 5,
                      );

                      final bool isTableEmpty =
                          controller.jumlahInput.value == 0;
                      final rowCount = controller.detailModel.length;

                      double rowHeight = 55.0; // Fixed height for each row
                      int maxRowsPerPage = 5; // Maximum number of rows per page
                      double headerHeight = 53.0; // Height of the header row

                      final double tableHeight = (isTableEmpty
                              ? headerHeight +
                                  rowHeight // Minimum height if table is empty
                              : headerHeight + (rowHeight * rowCount))
                          .clamp(headerHeight,
                              headerHeight + (rowHeight * maxRowsPerPage));

                      final emptyTable =
                          controller.detailModel.first.jumlahInput > 0;

                      return Column(
                        children: [
                          SizedBox(
                            height: tableHeight,
                            child: SfDataGrid(
                              source: dataSource,
                              columnWidthMode: emptyTable
                                  ? ColumnWidthMode.auto
                                  : ColumnWidthMode.fill,
                              gridLinesVisibility: GridLinesVisibility.both,
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
                                  columnName: 'No Container',
                                  label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'No Container',
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
                                  columnName: 'No Mesin',
                                  label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'No Mesin',
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
                                  columnName: 'No Rangka',
                                  label: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.lightBlue.shade100,
                                    ),
                                    child: Text(
                                      'No Rangka',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                if (emptyTable)
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
                                if (emptyTable)
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
                              pageCount: (controller.detailModel.length / 5)
                                  .ceilToDouble(),
                              direction: Axis.horizontal,
                            ),
                          if (rowCount > 5)
                            const SizedBox(height: CustomSize.md),
                        ],
                      );
                    }
                  }),
                  const SizedBox(height: CustomSize.sm),
                  Obx(() {
                    bool isJumlahSama =
                        controller.jumlahInput.value == model.jumlah;

                    return isJumlahSama
                        ? const SizedBox.shrink()
                        : Form(
                            key: controller.detailDefectKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Nomor Container'),
                                TextFormField(
                                  controller:
                                      controller.nomorContainerController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Bagian ini harus di isi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: CustomSize.sm),
                                const Text('Nomor Mesin'),
                                TextFormField(
                                  controller: controller.nomorMesinController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Bagian ini harus di isi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: CustomSize.sm),
                                const Text('Nomor Rangka'),
                                TextFormField(
                                  controller: controller.nomorRangkaController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Bagian ini harus di isi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                    height: CustomSize.spaceBtwSections),
                              ],
                            ),
                          );
                  }),
                  Obx(() {
                    bool isJumlahSama =
                        controller.jumlahInput.value == model.jumlah;

                    return Padding(
                      padding: EdgeInsets.only(
                        top: isJumlahSama ? CustomSize.md : 0,
                      ),
                      child: Row(
                        children: [
                          if (!isJumlahSama)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.addDetailDefect(
                                    model.idDefect,
                                    model.idDooring,
                                  );
                                },
                                child: const Text('Tambah'),
                              ),
                            ),
                          if (isJumlahSama) ...[
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () => Get.back(),
                                child: const Text('Kembali'),
                              ),
                            ),
                            const SizedBox(
                                width: CustomSize.sm), // Jarak antar tombol
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: () => controller.selesaiDetailDefect(
                                  model.idDefect,
                                  model.idDooring,
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: AppColors.success),
                                ),
                                child: const Text('Selesai'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ));
  }
}
