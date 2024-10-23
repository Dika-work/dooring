import 'package:dooring/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/dooring/jadwal_kapal_controller.dart';
import '../../../helpers/helper_func.dart';
import '../../../models/dooring/jadwal_kapal_model.dart';
import '../../constant/custom_size.dart';

class JadwalKapalSource extends DataGridSource {
  final void Function(int)? onLihat;
  final void Function(JadwalKapalModel, String)? addDooring;
  final void Function(JadwalKapalModel, String)? onEdited;
  final List<JadwalKapalModel> jadwalKapalModel;
  final bool isAdmin;

  JadwalKapalSource({
    required this.onLihat,
    required this.addDooring,
    required this.onEdited,
    required this.jadwalKapalModel,
    required this.isAdmin,
  }) {
    _updateDataPager(jadwalKapalModel);
  }

  List<DataGridRow> dooringData = [];
  final controller = Get.put(JadwalKapalController());
  int index = 0;

  @override
  List<DataGridRow> get rows => dooringData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = dooringData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    List<Widget> cells = [
      ...row.getCells().map<Widget>((e) {
        // print(
        //     'Membuat sel untuk kolom: ${e.columnName} dengan nilai: ${e.value}');
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          child: Text(
            e.value.toString(),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.normal, fontSize: CustomSize.fontSizeXm),
          ),
        );
      })
    ];

    if (controller.lihatRole != 0) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (jadwalKapalModel[rowIndex].totalUnit !=
                  jadwalKapalModel[rowIndex].unitDooring ||
              jadwalKapalModel[rowIndex].feet20 !=
                  jadwalKapalModel[rowIndex].ct20Dooring ||
              jadwalKapalModel[rowIndex].feet40 !=
                  jadwalKapalModel[rowIndex].ct40Dooring) ...[
            const Text(
              '-',
              textAlign: TextAlign.center,
            ),
          ] else if (jadwalKapalModel[rowIndex].totalUnit ==
                  jadwalKapalModel[rowIndex].unitDooring &&
              jadwalKapalModel[rowIndex].feet20 ==
                  jadwalKapalModel[rowIndex].ct20Dooring &&
              jadwalKapalModel[rowIndex].feet40 ==
                  jadwalKapalModel[rowIndex].ct40Dooring) ...[
            IconButton(
                onPressed: () {
                  if (onLihat != null) {
                    onLihat!(jadwalKapalModel[rowIndex].idJadwal);
                  } else {
                    return;
                  }
                },
                icon: const Icon(
                  Iconsax.eye,
                ))
          ]
        ],
      ));
    }

    if (controller.tambahRole != 0) {
      if (jadwalKapalModel[rowIndex].statusJadwal == 1) {
        cells.add(
          Center(
            child: Text(
              'SELESAI INPUT\n${CustomHelperFunctions.getFormattedDate(DateTime.parse(jadwalKapalModel[rowIndex].tglAcc))}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.success),
            ),
          ),
        );
      } else if ((jadwalKapalModel[rowIndex].totalUnit !=
                  jadwalKapalModel[rowIndex].unitDooring ||
              jadwalKapalModel[rowIndex].feet20 !=
                  jadwalKapalModel[rowIndex].ct20Dooring ||
              jadwalKapalModel[rowIndex].feet40 !=
                  jadwalKapalModel[rowIndex].ct40Dooring) &&
          jadwalKapalModel[rowIndex].statusJadwal == 0) {
        cells.add(
          IconButton(
            onPressed: () {
              if (addDooring != null && jadwalKapalModel.isNotEmpty) {
                addDooring!(jadwalKapalModel[rowIndex], 'add');
              }
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.success,
            ),
          ),
        );
      } else if (jadwalKapalModel[rowIndex].totalUnit ==
              jadwalKapalModel[rowIndex].unitDooring &&
          jadwalKapalModel[rowIndex].feet20 ==
              jadwalKapalModel[rowIndex].ct20Dooring &&
          jadwalKapalModel[rowIndex].feet40 ==
              jadwalKapalModel[rowIndex].ct40Dooring &&
          jadwalKapalModel[rowIndex].totalDooring ==
              jadwalKapalModel[rowIndex].totalStatusDefect) {
        print("Total Unit: ${jadwalKapalModel[rowIndex].totalUnit}");
        print("Unit Dooring: ${jadwalKapalModel[rowIndex].unitDooring}");
        print("Feet 20: ${jadwalKapalModel[rowIndex].feet20}");
        print("CT 20 Dooring: ${jadwalKapalModel[rowIndex].ct20Dooring}");
        print("Feet 40: ${jadwalKapalModel[rowIndex].feet40}");
        print("CT 40 Dooring: ${jadwalKapalModel[rowIndex].ct40Dooring}");
        print("Total Dooring: ${jadwalKapalModel[rowIndex].totalDooring}");
        print(
            "Total Status Defect: ${jadwalKapalModel[rowIndex].totalStatusDefect}");
        cells.add(
          IconButton(
            onPressed: () {
              if (addDooring != null && jadwalKapalModel.isNotEmpty) {
                addDooring!(jadwalKapalModel[rowIndex], 'check');
              }
            },
            icon: const Icon(
              Icons.check,
              color: AppColors.success,
            ),
          ),
        );
      } else if ((jadwalKapalModel[rowIndex].totalUnit ==
                  jadwalKapalModel[rowIndex].unitDooring &&
              jadwalKapalModel[rowIndex].feet20 ==
                  jadwalKapalModel[rowIndex].ct20Dooring &&
              jadwalKapalModel[rowIndex].feet40 ==
                  jadwalKapalModel[rowIndex].ct40Dooring) ||
          jadwalKapalModel[rowIndex].totalDooring !=
                  jadwalKapalModel[rowIndex].totalStatusDefect &&
              jadwalKapalModel[rowIndex].statusJadwal == 0) {
        cells.add(
          const Center(
            child: Text(
              'LENGKAPI DATA DOORING',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.error),
            ),
          ),
        );
      }
    }

    if (controller.editRole != 0) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if ((jadwalKapalModel[rowIndex].totalUnit !=
                      jadwalKapalModel[rowIndex].unitDooring ||
                  jadwalKapalModel[rowIndex].feet20 !=
                      jadwalKapalModel[rowIndex].ct20Dooring ||
                  jadwalKapalModel[rowIndex].feet40 !=
                      jadwalKapalModel[rowIndex].ct40Dooring) &&
              jadwalKapalModel[rowIndex].statusJadwal == 0) ...[
            IconButton(
                onPressed: () {
                  if (onEdited != null && jadwalKapalModel.isNotEmpty) {
                    onEdited!(jadwalKapalModel[rowIndex], 'edit');
                  } else {
                    return;
                  }
                },
                icon: const Icon(
                  Iconsax.edit,
                ))
          ] else if ((jadwalKapalModel[rowIndex].totalUnit ==
                      jadwalKapalModel[rowIndex].unitDooring &&
                  jadwalKapalModel[rowIndex].feet20 ==
                      jadwalKapalModel[rowIndex].ct20Dooring &&
                  jadwalKapalModel[rowIndex].feet40 ==
                      jadwalKapalModel[rowIndex].ct40Dooring) ||
              jadwalKapalModel[rowIndex].totalDooring !=
                      jadwalKapalModel[rowIndex].totalStatusDefect &&
                  jadwalKapalModel[rowIndex].statusJadwal == 0) ...[
            const Text(
              '-',
              textAlign: TextAlign.center,
            ),
          ] else if (jadwalKapalModel[rowIndex].statusJadwal == 1) ...[
            IconButton(
              onPressed: () {
                if (onEdited != null && jadwalKapalModel.isNotEmpty) {
                  onEdited!(jadwalKapalModel[rowIndex], 'cross');
                }
              },
              icon: const Icon(
                Icons.cancel_outlined,
              ),
            )
          ]
        ],
      ));
    }

    return DataGridRowAdapter(
      color: (isEvenRow ? Colors.white : Colors.grey[200]),
      cells: cells,
    );
  }

  Map<String, String> regionMapping = {
    'SAMARINDA': 'SRD',
    'MAKASSAR': 'MKS',
    'PONTIANAK': 'PTK',
    'BANJARMASIN': 'BJM',
    'JAKARTA': 'JKT'
  };

  void _updateDataPager(List<JadwalKapalModel> jadwalKapalModel) {
    final filteredData = isAdmin
        ? jadwalKapalModel
        : jadwalKapalModel
            .where((item) => item.wilayah == controller.roleWilayah)
            .toList();

    dooringData = filteredData.map<DataGridRow>(
      (e) {
        index++;

        final regionKey = regionMapping.keys.firstWhere(
          (region) => e.wilayah.contains(region),
          orElse: () => e.wilayah,
        );
        final regionValue = regionMapping[regionKey] ?? e.wilayah;

        final tglInput =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(e.tgl));
        final etd =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(e.etd));
        final atd =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(e.atd));

        // Cetak semua kolom yang akan digunakan
        final columns = [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(
              columnName: 'Nama Pelayaran', value: e.namaKapal),
          DataGridCell<String>(columnName: 'Tgl Input', value: tglInput),
          if (controller.isAdmin)
            DataGridCell<String>(columnName: 'Wilayah', value: regionValue),
          DataGridCell<String>(columnName: 'ETD', value: etd),
          DataGridCell<String>(columnName: 'ATD', value: atd),
          DataGridCell<int>(columnName: 'Total Unit', value: e.totalUnit),
          DataGridCell<int>(columnName: 'Total 20', value: e.feet20),
          DataGridCell<int>(columnName: 'Total 40', value: e.feet40),
          DataGridCell<int>(columnName: 'Bongkar Unit', value: e.unitDooring),
          DataGridCell<int>(columnName: 'Bongkar 20', value: e.ct20Dooring),
          DataGridCell<int>(columnName: 'Bongkar 40', value: e.ct40Dooring),
          DataGridCell<int>(columnName: 'Unit Dooring', value: e.unitDooring),
        ];

        return DataGridRow(cells: columns);
      },
    ).toList();
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(jadwalKapalModel);
    notifyListeners();
    return true;
  }
}


// class JadwalSeluruhKapalSource extends DataGridSource {
//   final void Function(int)? onLihat;
//   final void Function(SeluruhJadwalKapal, String)? addDooring;
//   final void Function(SeluruhJadwalKapal, String)? onEdited;
//   final List<SeluruhJadwalKapal> jadwalKapalModel;
//   final bool isAdmin;

//   JadwalSeluruhKapalSource({
//     required this.onLihat,
//     required this.addDooring,
//     required this.onEdited,
//     required this.jadwalKapalModel,
//     required this.isAdmin,
//   }) {
//     _updateDataPager(jadwalKapalModel);
//   }

//   List<DataGridRow> dooringData = [];
//   final controller = Get.put(JadwalKapalController());
//   int index = 0;

//   @override
//   List<DataGridRow> get rows => dooringData;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     int rowIndex = dooringData.indexOf(row);
//     bool isEvenRow = rowIndex % 2 == 0;

//     // Step 1: Default widget to add to cells

//     // Step 2: Check if `tglAcc` is valid and handle parsing in try-catch
//     int daysDifference = 0;
//     if (jadwalKapalModel[rowIndex].tglAcc.isNotEmpty) {
//       try {
//         DateTime tglAcc =
//             DateTime.parse(jadwalKapalModel[rowIndex].tglAcc); // Parse date
//         DateTime currentDate = DateTime.now();

//         // Step 3: Calculate the difference in days
//         daysDifference = currentDate.difference(tglAcc).inDays;
//         print('ini hari tgl acc nya $daysDifference');
//       } catch (e) {
//         print(
//             'Error parsing tglAcc for ${jadwalKapalModel[rowIndex].namaKapal}: $e');
//       }
//     }

//     List<Widget> cells = [
//       ...row.getCells().map<Widget>((e) {
//         // print(
//         //     'Membuat sel untuk kolom: ${e.columnName} dengan nilai: ${e.value}');
//         return Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
//           child: Text(
//             e.value.toString(),
//             maxLines: 2,
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//                 fontWeight: FontWeight.normal, fontSize: CustomSize.fontSizeXm),
//           ),
//         );
//       })
//     ];

//     if (controller.lihatRole != 0) {
//       cells.add(Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (jadwalKapalModel[rowIndex].totalUnit !=
//                   jadwalKapalModel[rowIndex].unitDooring ||
//               jadwalKapalModel[rowIndex].feet20 !=
//                   jadwalKapalModel[rowIndex].ct20Dooring ||
//               jadwalKapalModel[rowIndex].feet40 !=
//                   jadwalKapalModel[rowIndex].ct40Dooring) ...[
//             const Text(
//               '-',
//               textAlign: TextAlign.center,
//             ),
//           ] else if (jadwalKapalModel[rowIndex].totalUnit ==
//                   jadwalKapalModel[rowIndex].unitDooring &&
//               jadwalKapalModel[rowIndex].feet20 ==
//                   jadwalKapalModel[rowIndex].ct20Dooring &&
//               jadwalKapalModel[rowIndex].feet40 ==
//                   jadwalKapalModel[rowIndex].ct40Dooring) ...[
//             IconButton(
//                 onPressed: () {
//                   if (onLihat != null) {
//                     onLihat!(jadwalKapalModel[rowIndex].idJadwal);
//                   } else {
//                     return;
//                   }
//                 },
//                 icon: const Icon(
//                   Iconsax.eye,
//                 ))
//           ]
//         ],
//       ));
//       print("Menambahkan sel kolom Lihat");
//     }

//     if (controller.tambahRole != 0) {
//       cells.add(Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if ((jadwalKapalModel[rowIndex].totalUnit !=
//                       jadwalKapalModel[rowIndex].unitDooring ||
//                   jadwalKapalModel[rowIndex].feet20 !=
//                       jadwalKapalModel[rowIndex].ct20Dooring ||
//                   jadwalKapalModel[rowIndex].feet40 !=
//                       jadwalKapalModel[rowIndex].ct40Dooring) &&
//               jadwalKapalModel[rowIndex].statusJadwal == 0) ...[
//             IconButton(
//               onPressed: () {
//                 if (addDooring != null && jadwalKapalModel.isNotEmpty) {
//                   addDooring!(jadwalKapalModel[rowIndex], 'add');
//                 }
//               },
//               icon: const Icon(
//                 Icons.add,
//                 color: AppColors.success,
//               ),
//             ),
//           ] else if (jadwalKapalModel[rowIndex].totalUnit ==
//                   jadwalKapalModel[rowIndex].unitDooring &&
//               jadwalKapalModel[rowIndex].feet20 ==
//                   jadwalKapalModel[rowIndex].ct20Dooring &&
//               jadwalKapalModel[rowIndex].feet40 ==
//                   jadwalKapalModel[rowIndex].ct40Dooring &&
//               jadwalKapalModel[rowIndex].totalDooring ==
//                   jadwalKapalModel[rowIndex].totalStatusDefect) ...[
//             IconButton(
//               onPressed: () {
//                 if (addDooring != null && jadwalKapalModel.isNotEmpty) {
//                   addDooring!(jadwalKapalModel[rowIndex], 'check');
//                 }
//               },
//               icon: const Icon(
//                 Icons.check,
//                 color: AppColors.success,
//               ),
//             ),
//           ] else if ((jadwalKapalModel[rowIndex].totalUnit ==
//                       jadwalKapalModel[rowIndex].unitDooring &&
//                   jadwalKapalModel[rowIndex].feet20 ==
//                       jadwalKapalModel[rowIndex].ct20Dooring &&
//                   jadwalKapalModel[rowIndex].feet40 ==
//                       jadwalKapalModel[rowIndex].ct40Dooring) ||
//               jadwalKapalModel[rowIndex].totalDooring !=
//                       jadwalKapalModel[rowIndex].totalStatusDefect &&
//                   jadwalKapalModel[rowIndex].statusJadwal == 0) ...[
//             const Text(
//               'LENGKAPI DATA DOORING',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold, color: AppColors.error),
//             ),
//           ] else if (jadwalKapalModel[rowIndex].statusJadwal == 1) ...[
//             Text(
//               'SELESAI INPUT\n${CustomHelperFunctions.getFormattedDate(DateTime.parse(jadwalKapalModel[rowIndex].tglAcc))}',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold, color: AppColors.success),
//             ),
//           ]
//         ],
//       ));
//       print("Menambahkan sel kolom Tambah Dooring");
//     }

//     if (controller.editRole != 0) {
//       cells.add(Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if ((jadwalKapalModel[rowIndex].totalUnit !=
//                       jadwalKapalModel[rowIndex].unitDooring ||
//                   jadwalKapalModel[rowIndex].feet20 !=
//                       jadwalKapalModel[rowIndex].ct20Dooring ||
//                   jadwalKapalModel[rowIndex].feet40 !=
//                       jadwalKapalModel[rowIndex].ct40Dooring) &&
//               jadwalKapalModel[rowIndex].statusJadwal == 0) ...[
//             IconButton(
//                 onPressed: () {
//                   if (onEdited != null && jadwalKapalModel.isNotEmpty) {
//                     onEdited!(jadwalKapalModel[rowIndex], 'edit');
//                   } else {
//                     return;
//                   }
//                 },
//                 icon: const Icon(
//                   Iconsax.edit,
//                 ))
//           ] else if ((jadwalKapalModel[rowIndex].totalUnit ==
//                       jadwalKapalModel[rowIndex].unitDooring &&
//                   jadwalKapalModel[rowIndex].feet20 ==
//                       jadwalKapalModel[rowIndex].ct20Dooring &&
//                   jadwalKapalModel[rowIndex].feet40 ==
//                       jadwalKapalModel[rowIndex].ct40Dooring) ||
//               jadwalKapalModel[rowIndex].totalDooring !=
//                       jadwalKapalModel[rowIndex].totalStatusDefect &&
//                   jadwalKapalModel[rowIndex].statusJadwal == 0) ...[
//             const Text(
//               '-',
//               textAlign: TextAlign.center,
//             ),
//           ] else if (jadwalKapalModel[rowIndex].statusJadwal == 1 &&
//               daysDifference <= 7) ...[
//             IconButton(
//               onPressed: () {
//                 if (onEdited != null && jadwalKapalModel.isNotEmpty) {
//                   onEdited!(jadwalKapalModel[rowIndex], 'cross');
//                 }
//               },
//               icon: const Icon(
//                 Icons.cancel_outlined,
//               ),
//             )
//           ] else if (jadwalKapalModel[rowIndex].statusJadwal == 1 &&
//               daysDifference >= 7) ...[
//             const SizedBox.shrink()
//           ]
//         ],
//       ));
//       print("Menambahkan sel kolom Edit");
//     }

//     print('Total sel yang dibuat: ${cells.length}');

//     return DataGridRowAdapter(
//       color: (isEvenRow ? Colors.white : Colors.grey[200]),
//       cells: cells,
//     );
//   }

//   Map<String, String> regionMapping = {
//     'SAMARINDA': 'SRD',
//     'MAKASSAR': 'MKS',
//     'PONTIANAK': 'PTK',
//     'BANJARMASIN': 'BJM',
//     'JAKARTA': 'JKT'
//   };

//   void _updateDataPager(List<JadwalKapalModel> jadwalKapalModel) {
//     final filteredData = isAdmin
//         ? jadwalKapalModel
//         : jadwalKapalModel
//             .where((item) => item.wilayah == controller.roleWilayah)
//             .toList();

//     dooringData = filteredData.map<DataGridRow>(
//       (e) {
//         index++;

//         final regionKey = regionMapping.keys.firstWhere(
//           (region) => e.wilayah.contains(region),
//           orElse: () => e.wilayah,
//         );
//         final regionValue = regionMapping[regionKey] ?? e.wilayah;

//         final tglInput =
//             CustomHelperFunctions.getFormattedDate(DateTime.parse(e.tgl));
//         final etd =
//             CustomHelperFunctions.getFormattedDate(DateTime.parse(e.etd));
//         final atd =
//             CustomHelperFunctions.getFormattedDate(DateTime.parse(e.atd));

//         print('Membuat kolom untuk wilayah: $regionValue');

//         // Cetak semua kolom yang akan digunakan
//         final columns = [
//           DataGridCell<int>(columnName: 'No', value: index),
//           DataGridCell<String>(
//               columnName: 'Nama Pelayaran', value: e.namaKapal),
//           DataGridCell<String>(columnName: 'Tgl Input', value: tglInput),
//           if (controller.isAdmin)
//             DataGridCell<String>(columnName: 'Wilayah', value: regionValue),
//           DataGridCell<String>(columnName: 'ETD', value: etd),
//           DataGridCell<String>(columnName: 'ATD', value: atd),
//           DataGridCell<int>(columnName: 'Total Unit', value: e.totalUnit),
//           DataGridCell<int>(columnName: 'Total 20', value: e.feet20),
//           DataGridCell<int>(columnName: 'Total 40', value: e.feet40),
//           DataGridCell<int>(columnName: 'Bongkar Unit', value: e.unitDooring),
//           DataGridCell<int>(columnName: 'Bongkar 20', value: e.ct20Dooring),
//           DataGridCell<int>(columnName: 'Bongkar 40', value: e.ct40Dooring),
//           DataGridCell<int>(columnName: 'Unit Dooring', value: e.unitDooring),
//         ];

//         // Cetak jumlah kolom yang digunakan dalam setiap baris
//         print('Total kolom yang dibuat: ${columns.length}');
//         return DataGridRow(cells: columns);
//       },
//     ).toList();
//     notifyListeners();
//   }

//   @override
//   Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
//     _updateDataPager(jadwalKapalModel);
//     notifyListeners();
//     return true;
//   }
// }
