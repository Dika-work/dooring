import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/kapal_controller.dart';
import '../../models/dooring/dooring_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/dooring/lihat_dooring_source.dart';
import '../../utils/theme/app_colors.dart';

class LihatDooring extends StatelessWidget {
  const LihatDooring({super.key, required this.model});

  final DooringModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TypeMotorController());

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.fetchDefetchTable(model.idDooring);
        controller.lihatDooring(model.idDooring);
      },
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text('Lihat Data Dooring',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: ListView(
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
            controller: TextEditingController(text: model.etd),
            readOnly: true,
          ),
          const SizedBox(height: CustomSize.sm),
          const Text('Tgl Bongkar'),
          TextFormField(
            controller: TextEditingController(text: model.tglBongkar),
            readOnly: true,
          ),
          const SizedBox(height: CustomSize.sm),
          const Text('Total Unit'),
          TextFormField(
            controller: TextEditingController(text: model.unit.toString()),
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
                      controller:
                          TextEditingController(text: model.helm1.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('Accu'),
                    TextFormField(
                      controller:
                          TextEditingController(text: model.accu1.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('Spion'),
                    TextFormField(
                      controller:
                          TextEditingController(text: model.spion1.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('Buser'),
                    TextFormField(
                      controller:
                          TextEditingController(text: model.buser1.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('ToolSeet'),
                    TextFormField(
                      controller: TextEditingController(
                          text: model.toolset1.toString()),
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
                          text: model.helmKurang.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('Accu Kurang'),
                    TextFormField(
                      controller: TextEditingController(
                          text: model.accuKurang.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('Spion Kurang'),
                    TextFormField(
                      controller: TextEditingController(
                          text: model.spionKurang.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('Buser Kurang'),
                    TextFormField(
                      controller: TextEditingController(
                          text: model.buserKurang.toString()),
                      readOnly: true,
                    ),
                    const SizedBox(height: CustomSize.sm),
                    const Text('ToolSet Kurang'),
                    TextFormField(
                      controller: TextEditingController(
                          text: model.totalsetKurang.toString()),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Obx(() {
            if (controller.isLoading.value && controller.defectModel.isEmpty) {
              return const CustomCircularLoader();
            } else {
              final dataSource = LihatDooringSource(
                defectModel: controller.defectModel,
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
          const SizedBox(height: CustomSize.spaceBtwItems),
          Obx(() {
            if (controller.isLoading.value && controller.defectModel.isEmpty) {
              return const CustomCircularLoader();
            } else {
              final dataSource = DetailLihatSource(
                defectModel: controller.detailDefectModel,
              );

              final bool isTableEmpty = controller.detailDefectModel.isEmpty;
              final rowCount = controller.detailDefectModel.length;

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
                      ],
                    ),
                  ),
                  if (rowCount > 5)
                    SfDataPager(
                      delegate: dataSource,
                      pageCount: (controller.detailDefectModel.length / 5)
                          .ceilToDouble(),
                      direction: Axis.horizontal,
                    ),
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
                    onPressed: () => Get.back(), child: const Text('Kembali')),
              ),
              const SizedBox(width: CustomSize.md),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () =>
                        controller.downloadExcelForDooring(model.idDooring),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success),
                    child: const Icon(Iconsax.document_download)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
