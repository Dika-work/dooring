import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/laporan/jumlah_defect_controller.dart';
import '../../controllers/laporan/total_unit_controller.dart';
import '../../helpers/connectivity.dart';
import '../../models/laporan/jumlah_defect_model.dart';
import '../../models/laporan/total_unit_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/shimmer.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/laporan/jumlah_defect_source.dart';
import '../../utils/source/laporan/total_unit_source.dart';
import '../../widgets/dropdown.dart';

class TotalUnit extends StatefulWidget {
  const TotalUnit({super.key});

  @override
  State<TotalUnit> createState() => _TotalUnitState();
}

class _TotalUnitState extends State<TotalUnit> {
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Des'
  ];

  List<String> years = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
  ];

  String selectedYear = DateTime.now().year.toString();

  TotalUnitSource? totalUnitSource;
  JumlahDefectSource? jumlahDefectSource;
  final controller = Get.put(TotalUnitController());
  final jumlahDefectController = Get.put(JumlahDefectController());
  final networkConn = Get.find<NetworkManager>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataAndRefreshSource();
    });
  }

  Future<void> _fetchDataAndRefreshSource() async {
    if (!await networkConn.isConnected()) {
      SnackbarLoader.errorSnackBar(
        title: 'Koneksi Terputus',
        message: 'Anda telah kehilangan koneksi internet.',
      );
    }
    try {
      print('Memulai pengambilan data di _fetchDataAndRefreshSource');
      await controller.fetchTotalUnitData(int.parse(selectedYear));
      await jumlahDefectController.fetchTotalUnitData(int.parse(selectedYear));
      print('Data berhasil diambil');
    } catch (e) {
      print('Error saat fetch data di _fetchDataAndRefreshSource: $e');

      controller.samarindaModel.assignAll(
          _generateDefaultData()); // Jika gagal ambil data, gunakan data default
      jumlahDefectController.samarindaModel.assignAll(_generateDefaultDefect());
    }
    _updateLaporanSource();
    _updateJumlahDefect();
  }

  // Metode untuk menghasilkan data default (bulan 1-12, hasil = 0)
  List<TotalUnitModel> _generateDefaultData() {
    List<TotalUnitModel> defaultData = [];
    for (int i = 1; i <= 12; i++) {
      defaultData.add(TotalUnitModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "SAMARINDA",
        totalUnit: 0,
      ));
      defaultData.add(TotalUnitModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "MAKASSAR",
        totalUnit: 0,
      ));
      defaultData.add(TotalUnitModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "PONTIANAK",
        totalUnit: 0,
      ));
      defaultData.add(TotalUnitModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "BANJARMASIN",
        totalUnit: 0,
      ));
    }
    return defaultData;
  }

  // data table kosong untuk jumlah defect
  List<JumlahDefectModel> _generateDefaultDefect() {
    List<JumlahDefectModel> defaultData = [];
    for (int i = 1; i <= 12; i++) {
      defaultData.add(JumlahDefectModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "SAMARINDA",
        totalJumlah: 0,
      ));
      defaultData.add(JumlahDefectModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "MAKASSAR",
        totalJumlah: 0,
      ));
      defaultData.add(JumlahDefectModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "PONTIANAK",
        totalJumlah: 0,
      ));
      defaultData.add(JumlahDefectModel(
        bulan: i,
        tahun: int.parse(selectedYear),
        wilayah: "BANJARMASIN",
        totalJumlah: 0,
      ));
    }
    return defaultData;
  }

  void _updateLaporanSource() {
    setState(() {
      totalUnitSource = TotalUnitSource(
        selectedYear: int.parse(selectedYear),
        totalUnitModel: controller.samarindaModel,
      );
    });
  }

  void _updateJumlahDefect() {
    setState(() {
      jumlahDefectSource = JumlahDefectSource(
        selectedYear: int.parse(selectedYear),
        jumlahDefectModel: jumlahDefectController.samarindaModel,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    late Map<String, double> columnWidths = {
      'Wilayah': 135,
      'Bulan': double.nan,
      'TOTAL': double.nan,
    };

    const double rowHeight = 50.0;
    const double headerHeight = 65.0;

    const double gridHeight = headerHeight + (rowHeight * 5);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Laporan Total Unit',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _fetchDataAndRefreshSource(),
        child: ListView(
          padding: const EdgeInsets.symmetric(
              vertical: CustomSize.md, horizontal: CustomSize.sm),
          children: [
            totalUnitSource != null && jumlahDefectSource != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropDownWidget(
                          value: selectedYear,
                          items: years,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedYear = newValue!;
                              print('INI TAHUN YANG DI PILIH $selectedYear');
                              _fetchDataAndRefreshSource();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: CustomSize.sm),
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            _fetchDataAndRefreshSource();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: CustomSize.md)),
                          child: const Icon(Iconsax.calendar_search),
                        ),
                      )
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          )),
                      const SizedBox(width: CustomSize.sm),
                      Expanded(
                          flex: 1,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          )),
                    ],
                  ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            SizedBox(
              height: gridHeight,
              child: totalUnitSource != null
                  ? SfDataGrid(
                      source: totalUnitSource!,
                      frozenColumnsCount: 1,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      verticalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      allowColumnsResizing: true,
                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
                      stackedHeaderRows: [
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: [
                              'Bulan 1',
                              'Bulan 2',
                              'Bulan 3',
                              'Bulan 4',
                              'Bulan 5',
                              'Bulan 6',
                              'Bulan 7',
                              'Bulan 8',
                              'Bulan 9',
                              'Bulan 10',
                              'Bulan 11',
                              'Bulan 12'
                            ], // Kolom bulan yang sesuai
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'Bulan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]),
                      ],
                      columns: [
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
                            ),
                          ),
                        ),
                        for (int i = 0; i < 12; i++)
                          GridColumn(
                            width: columnWidths['Bulan']!,
                            columnName: 'Bulan ${i + 1}',
                            label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                months[
                                    i], // Menampilkan nama bulan (Jan, Feb, dst.)
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
                          width: columnWidths['TOTAL']!,
                          columnName: 'TOTAL',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'TOTAL',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const CustomShimmerEffect(
                      height: 200,
                      width: double.infinity,
                    ), // Tampilkan loading jika null
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            SizedBox(
              height: gridHeight,
              child: jumlahDefectSource != null
                  ? SfDataGrid(
                      source: jumlahDefectSource!,
                      frozenColumnsCount: 1,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      verticalScrollPhysics:
                          const NeverScrollableScrollPhysics(),
                      allowColumnsResizing: true,
                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        columnWidths[details.column.columnName] = details.width;
                        return true;
                      },
                      stackedHeaderRows: [
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: [
                              'Bulan 1',
                              'Bulan 2',
                              'Bulan 3',
                              'Bulan 4',
                              'Bulan 5',
                              'Bulan 6',
                              'Bulan 7',
                              'Bulan 8',
                              'Bulan 9',
                              'Bulan 10',
                              'Bulan 11',
                              'Bulan 12'
                            ], // Kolom bulan yang sesuai
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: const Text(
                                'Bulan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]),
                      ],
                      columns: [
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
                            ),
                          ),
                        ),
                        for (int i = 0; i < 12; i++)
                          GridColumn(
                            width: columnWidths['Bulan']!,
                            columnName: 'Bulan ${i + 1}',
                            label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                months[
                                    i], // Menampilkan nama bulan (Jan, Feb, dst.)
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
                          width: columnWidths['TOTAL']!,
                          columnName: 'TOTAL',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'TOTAL',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const CustomShimmerEffect(
                      height: 200,
                      width: double.infinity,
                    ), // Tampilkan loading jika null
            )
          ],
        ),
      ),
    );
  }
}
