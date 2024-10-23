import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/jadwal_kapal_acc_controller.dart';
import '../../models/dooring/jadwal_kapal_acc_model.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/dooring/jadwal_kapal_acc_source.dart';

class JadwalKapalAcc extends GetView<JadwalKapalAccController> {
  const JadwalKapalAcc({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.fetchJadwalKapalAcc();
      },
    );

    late Map<String, double> columnWidths = {
      'No': 50,
      'Tgl Input': 70,
      'Nama Pelayaran': 150,
      'ETD': 100,
      'ATD': 100,
      'Total Unit': 80,
      'Total 20': 80,
      'Total 40': 80,
      'Bongkar Unit': 100,
      'Bongkar 20': 100,
      'Bongkar 40': 100,
      if (controller.lihatRole != 0) 'Lihat': 80,
      if (controller.editRole != 0) 'Edit': 80,
    };
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Jadwal Kapal',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.jadwalKapalAccModel.isEmpty) {
          return const CustomCircularLoader();
        }
        // else if (controller.allDooringModel.isEmpty) {
        //   return CustomAnimationLoaderWidget(
        //     text: 'Tidak ada data saat ini',
        //     animation: 'assets/animations/404.json',
        //     height: CustomHelperFunctions.screenHeight() * 0.4,
        //     width: CustomHelperFunctions.screenHeight(),
        //   );
        // }
        else {
          final dataSource = JadwalKapalAccSource(
            onLihat: (JadwalKapalAccModel model) {},
            onEdit: (JadwalKapalAccModel model) {
              print('ini edit jadwal kapal');
            },
            jadwalKapalAccModel: controller.jadwalKapalAccModel,
          );

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchJadwalKapalAcc();
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
                      width: columnWidths['ATD']!,
                      columnName: 'ATD',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'ATD',
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
                      width: columnWidths['Total 20']!,
                      columnName: 'Total 20',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Total 20',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Total 40']!,
                      columnName: 'Total 40',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Total 40',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Bongkar Unit']!,
                      columnName: 'Bongkar Unit',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Bongkar Unit',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Bongkar 20']!,
                      columnName: 'Bongkar 20',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Bongkar 20',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Bongkar 40']!,
                      columnName: 'Bongkar 40',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Bongkar 40',
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
