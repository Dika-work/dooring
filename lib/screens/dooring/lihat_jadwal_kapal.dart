import 'package:dooring/helpers/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/jadwal_kapal_controller.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/dooring/lihat_jadwal_kapal_source.dart';
import '../../utils/theme/app_colors.dart';

class LihatJadwalKapal extends StatelessWidget {
  const LihatJadwalKapal({
    super.key,
    required this.idJadwal,
    required this.controller,
  });

  final int idJadwal;
  final JadwalKapalController controller;

  @override
  Widget build(BuildContext context) {
    // Panggil controller untuk mengambil data berdasarkan idJadwal
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller
            .lihatJadwalKapal(idJadwal); // Panggil fungsi lihatJadwalKapal
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text('Lihat Jadwal Kapal',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Obx(() {
        // Jika masih loading, tampilkan indikator loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Cari model di dalam list berdasarkan idJadwal
        final model = controller.lihatJadwalKapalModel.firstWhereOrNull(
          (item) =>
              item.idJadwal == idJadwal, // Cari model dengan id yang cocok
        );

        // Jika model tidak ditemukan, tampilkan pesan kesalahan
        if (model == null) {
          return Center(child: Text('Data tidak ditemukan $idJadwal'));
        }

        String getKelebihan(int hasil) => hasil < 0 ? (-hasil).toString() : '0';
        String getKekurangan(int hasil) => hasil > 0 ? hasil.toString() : '0';

        // Gunakan model yang ditemukan untuk menampilkan data
        return ListView(
          padding: const EdgeInsets.symmetric(
              horizontal: CustomSize.md, vertical: CustomSize.sm),
          children: [
            const Text('Nama Kapal'),
            TextFormField(
              controller: TextEditingController(text: model.namaKapal),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('ETD'),
            TextFormField(
              controller: TextEditingController(
                  text: CustomHelperFunctions.getFormattedDate(
                      DateTime.parse(model.etd))),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('ATD'),
            TextFormField(
              controller: TextEditingController(
                  text: CustomHelperFunctions.getFormattedDate(
                      DateTime.parse(model.atd))),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Total Unit'),
            TextFormField(
              controller:
                  TextEditingController(text: model.totalUnit.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Total CT 20'),
            TextFormField(
              controller: TextEditingController(text: model.feet20.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Total CT 40'),
            TextFormField(
              controller: TextEditingController(text: model.feet40.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Wilayah'),
            TextFormField(
              controller: TextEditingController(text: model.wilayah),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Center(
              child: Text('TOTAL ALAT - ALAT MOTOR',
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            const Text('Helm'),
            TextFormField(
              controller: TextEditingController(text: model.helmL.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Accu'),
            TextFormField(
              controller: TextEditingController(text: model.accuL.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Spion'),
            TextFormField(
              controller: TextEditingController(text: model.spionL.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Buser'),
            TextFormField(
              controller: TextEditingController(text: model.buserL.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.sm),
            const Text('Toolset'),
            TextFormField(
              controller:
                  TextEditingController(text: model.toolsetL.toString()),
              readOnly: true,
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('KSU KELEBIHAN',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.apply(color: AppColors.success)),
                      ),
                      const SizedBox(height: CustomSize.md),
                      const Text('Helm'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKelebihan(model.hasilHelmL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('Accu'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKelebihan(model.hasilAccuL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('Spion'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKelebihan(model.hasilSpionL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('Buser'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKelebihan(model.hasilBuserL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('ToolSeet'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKelebihan(model.hasilToolSetL)),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: CustomSize.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Text('KSU KURANG',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.apply(color: AppColors.error)),
                      ),
                      const SizedBox(height: CustomSize.md),
                      const Text('Helm Kurang'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKekurangan(model.hasilHelmL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('Accu Kurang'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKekurangan(model.hasilAccuL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('Spion Kurang'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKekurangan(model.hasilSpionL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('Buser Kurang'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKekurangan(model.hasilBuserL)),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      const Text('ToolSet Kurang'),
                      TextFormField(
                        controller: TextEditingController(
                            text: getKekurangan(model.hasilToolSetL)),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: CustomSize.spaceBtwItems),
            // ! Tinggal Kedua Table Pada Lihat Jadwal Kapal Aja Belum Sesuai
            // ! Di karenakan API nya itu malah jadi satu
            Obx(() {
              if (controller.isLoading.value &&
                  controller.lihatJadwalKapalModel.isEmpty) {
                return const CustomCircularLoader();
              } else {
                final dataSource = LihatJadwalKapalSource(
                  defectModel: controller.lihatJadwalKapalModel,
                  context: context,
                );

                // Filter data yang 'typeMotor' dan 'part' tidak null
                final validRows = controller.lihatJadwalKapalModel.where((e) {
                  return e.typeMotor != null &&
                      e.part != null &&
                      e.typeMotor!.isNotEmpty &&
                      e.part!.isNotEmpty;
                }).toList();

                final bool isTableEmpty = validRows.isEmpty;
                final rowCount = validRows.length;

                // Tentukan gridHeight maksimum
                double gridHeight = 35.0 + (55.0 * 5);

                // Tentukan tinggi tabel berdasarkan baris valid
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
                        columnWidthMode: ColumnWidthMode.fill,
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
                            width: 50,
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
                        ],
                      ),
                    ),
                    if (rowCount > 5) const Divider(),
                    if (rowCount > 5)
                      SfDataPager(
                        delegate: dataSource,
                        pageCount: (controller.lihatJadwalKapalModel.length / 5)
                            .ceilToDouble(),
                        direction: Axis.horizontal,
                      ),
                    if (rowCount > 5) const Divider(),
                  ],
                );
              }
            }),
            Obx(() {
              if (controller.lihatJadwalKapalModel.length <= 5) {
                return const SizedBox(
                  height: CustomSize.defaultSpace,
                );
              } else {
                return const SizedBox.shrink(); // Mengembalikan widget kosong
              }
            }),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.lihatJadwalKapalModel.isEmpty) {
                return const CustomCircularLoader();
              } else {
                final dataSource = DetailLihatJadwalKapalSource(
                  defectModel: controller.lihatJadwalKapalModel,
                );

                // Filter data yang 'typeMotor' dan 'part' tidak null
                final validRows = controller.lihatJadwalKapalModel.where((e) {
                  return e.typeMotor != null &&
                      e.part != null &&
                      e.typeMotor!.isNotEmpty &&
                      e.part!.isNotEmpty;
                }).toList();

                final bool isTableEmpty = validRows.isEmpty;
                final rowCount = validRows.length;

                // Tentukan gridHeight maksimum
                double gridHeight = 35.0 + (55.0 * 5);

                // Tentukan tinggi tabel berdasarkan baris valid
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
                                textAlign: TextAlign.center,
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
                                textAlign: TextAlign.center,
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
                                textAlign: TextAlign.center,
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
                                textAlign: TextAlign.center,
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
                    if (rowCount > 5) const Divider(),
                    if (rowCount > 5)
                      SfDataPager(
                        delegate: dataSource,
                        pageCount: (controller.lihatJadwalKapalModel.length / 5)
                            .ceilToDouble(),
                        direction: Axis.horizontal,
                      ),
                    if (rowCount > 5) const Divider(),
                  ],
                );
              }
            }),
            const SizedBox(height: CustomSize.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Kembali')),
                ),
                const SizedBox(width: CustomSize.md),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () =>
                          controller.downloadExcelForDooring(model.idJadwal),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success),
                      child: const Icon(Iconsax.document_download)),
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}
