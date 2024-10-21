import 'package:dooring/controllers/laporan/laporan_defect_controller.dart';
import 'package:dooring/utils/constant/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../helpers/connectivity.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/shimmer.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/laporan/laporan_defect_source.dart';
import '../../utils/theme/app_colors.dart';
import '../../widgets/dropdown.dart';

class LaporanDefect extends StatefulWidget {
  const LaporanDefect({super.key});

  @override
  State<LaporanDefect> createState() => _LaporanDefectState();
}

class _LaporanDefectState extends State<LaporanDefect> {
  int totalRows = 0;

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

  final storageUtil = StorageUtil();

  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateFormat('MMM').format(DateTime.now());

  LaporanDefectTypeSource? typeSource;
  LaporanDefectPartSource? partSource;
  LaporanAllDefectTypeSource? allTypeSource;
  LaporanAllDefectPartSource? allPartSource;
  final controller = Get.put(LaporanDefectController());
  final networkConn = Get.find<NetworkManager>();

  int rowsPerPage = 10;
  int currentPage = 0;
  double rowHeight = 50.0;
  double headerHeight = 55.0;

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
      return;
    }

    final user = storageUtil.getUserDetails();

    // Ambil bulan sekarang dari DateTime.now() dan format dengan dua digit
    String formattedMonth =
        (months.indexOf(selectedMonth) + 1).toString().padLeft(2, '0');

    // Gunakan bulan dan tahun saat ini untuk fetch data
    await controller.fetchDefectType(
      int.parse(formattedMonth),
      int.parse(selectedYear),
      user!.wilayah,
    );
    await controller.fetchDefectPart(
      int.parse(formattedMonth),
      int.parse(selectedYear),
      user.wilayah,
    );

    // ini all data dari defect type dan part
    await controller.allFetchDefectType(
      int.parse(formattedMonth),
      int.parse(selectedYear),
      user.wilayah,
    );
    await controller.allFetchDefectPart(
      int.parse(formattedMonth),
      int.parse(selectedYear),
      user.wilayah,
    );

    // Debugging log
    // print('ini bulan: $formattedMonth');
    // print('ini tahun: $selectedYear');
    // print('ini wilayah user yang login: ${user.wilayah}');

    // Debugging: print data lengths to ensure correct fetching
    print(
        'Fetched defectTypeModel length: ${controller.defectTypeModel.length}');
    print(
        'Fetched defectPartModel length: ${controller.defectPartModel.length}');

    _updateTypeSource();
    _updatePartDefect();
    _updateAllTypeSource();
    _updateAllPartDefect();
  }

  void _updateTypeSource() {
    totalRows = controller.defectTypeModel.length;
    setState(() {
      typeSource = LaporanDefectTypeSource(
        detailDefectModel: controller.defectTypeModel,
        startIndex: currentPage * rowsPerPage,
      );
    });
  }

  void _updatePartDefect() {
    setState(() {
      partSource = LaporanDefectPartSource(
          detailDefectModel: controller.defectPartModel,
          startIndex: currentPage * rowsPerPage);
    });
  }

  // ini all data dari defect type dan part
  void _updateAllTypeSource() {
    totalRows = controller.defectTypeModel.length;
    setState(() {
      allTypeSource = LaporanAllDefectTypeSource(
        detailDefectModel: controller.allDefectTypeModel,
        startIndex: currentPage * rowsPerPage,
      );
    });
  }

  void _updateAllPartDefect() {
    setState(() {
      allPartSource = LaporanAllDefectPartSource(
          detailDefectModel: controller.allDefectPartModel,
          startIndex: currentPage * rowsPerPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate gridHeight dynamically based on the number of rows
    int typeSourceLength = controller.defectTypeModel.length;
    int partSourceLength = controller.defectPartModel.length;

    // Grid height should be dynamically calculated
    double gridHeightType = headerHeight +
        (rowHeight * (typeSourceLength > 0 ? typeSourceLength : 1));
    double gridHeightPart = headerHeight +
        (rowHeight * (partSourceLength > 0 ? partSourceLength : 1));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Laporan Defect',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchDataAndRefreshSource();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(
              vertical: CustomSize.md, horizontal: CustomSize.sm),
          children: [
            typeSource != null &&
                    partSource != null &&
                    allTypeSource != null &&
                    allPartSource != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropDownWidget(
                          // Pastikan 'selectedMonth' ada dalam List 'months'
                          value:
                              selectedMonth, // Format singkatan: 'Jan', 'Feb', dst.
                          items: months,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMonth =
                                  newValue!; // Simpan nilai yang dipilih
                              _fetchDataAndRefreshSource(); // Fetch data baru
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: CustomSize.sm),
                      Expanded(
                        flex: 2,
                        child: DropDownWidget(
                          value:
                              selectedYear, // Pastikan 'selectedYear' ada dalam List 'years'
                          items: years,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedYear =
                                  newValue!; // Simpan nilai yang dipilih
                              _fetchDataAndRefreshSource(); // Fetch data baru
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: CustomSize.sm),
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () async {
                            await _fetchDataAndRefreshSource(); // Fetch data dengan parameter bulan/tahun baru
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: CustomSize.md),
                          ),
                          child: const Icon(Iconsax.calendar_search),
                        ),
                      ),
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
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          )),
                      const SizedBox(width: CustomSize.sm),
                      Expanded(
                          flex: 2,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.white,
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
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          )),
                    ],
                  ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Center(
              child: Text('TOP 10 DATA DEFECT TYPE MOTOR',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            typeSource != null
                ? SizedBox(
                    height: gridHeightType,
                    child: SfDataGrid(
                      source: typeSource!,
                      columnWidthMode: ColumnWidthMode.fill,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      verticalScrollPhysics:
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
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                              'Type Motor', // Menampilkan nama bulan (Jan, Feb, dst.)
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
                          columnName: 'Total Defect',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Total Defect',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CustomShimmerEffect(
                    height: 200,
                    width: double.infinity,
                  ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Center(
              child: Text('TOP 10 DATA DEFECT PART MOTOR',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            partSource != null
                ? SizedBox(
                    height: gridHeightPart,
                    child: SfDataGrid(
                      source: partSource!,
                      columnWidthMode: ColumnWidthMode.fill,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      verticalScrollPhysics:
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
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                              'Part Motor', // Menampilkan nama bulan (Jan, Feb, dst.)
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
                          columnName: 'Total Defect',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Total Defect',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CustomShimmerEffect(
                    height: 200,
                    width: double.infinity,
                  ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Center(
              child: Text('SELURUH DATA DEFECT TYPE MOTOR',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            allTypeSource != null
                ? SizedBox(
                    height: gridHeightType,
                    child: SfDataGrid(
                      source: allTypeSource!,
                      columnWidthMode: ColumnWidthMode.fill,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      verticalScrollPhysics:
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
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                              'Type Motor', // Menampilkan nama bulan (Jan, Feb, dst.)
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
                          columnName: 'Total Defect',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Total Defect',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CustomShimmerEffect(
                    height: 200,
                    width: double.infinity,
                  ),
            if (allTypeSource != null)
              if (controller.allDefectTypeModel.length > 10)
                Center(
                  child: SfDataPager(
                    delegate: allTypeSource!,
                    pageCount: (controller.allDefectTypeModel.length / 10)
                        .ceilToDouble(),
                    direction: Axis.horizontal,
                  ),
                ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            Center(
              child: Text('SELURUH DATA DEFECT PART MOTOR',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: CustomSize.spaceBtwInputFields),
            allPartSource != null
                ? SizedBox(
                    height: gridHeightType,
                    child: SfDataGrid(
                      source: allPartSource!,
                      columnWidthMode: ColumnWidthMode.fill,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      verticalScrollPhysics:
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
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                              'Type Motor', // Menampilkan nama bulan (Jan, Feb, dst.)
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
                          columnName: 'Total Defect',
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Total Defect',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CustomShimmerEffect(
                    height: 200,
                    width: double.infinity,
                  ),
            if (allPartSource != null)
              if (controller.allDefectPartModel.length > 10)
                Center(
                  child: SfDataPager(
                    delegate: allPartSource!,
                    pageCount: (controller.allDefectPartModel.length / 10)
                        .ceilToDouble(),
                    direction: Axis.horizontal,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
