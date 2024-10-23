import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/dooring/jadwal_kapal_acc_controller.dart';
import '../../../helpers/helper_func.dart';
import '../../../models/dooring/jadwal_kapal_acc_model.dart';
import '../../constant/custom_size.dart';

class JadwalKapalAccSource extends DataGridSource {
  final void Function(JadwalKapalAccModel)? onLihat;
  final void Function(JadwalKapalAccModel)? onEdit;
  final List<JadwalKapalAccModel> jadwalKapalAccModel;

  JadwalKapalAccSource({
    required this.onLihat,
    required this.onEdit,
    required this.jadwalKapalAccModel,
  }) {
    _updateDataPager(jadwalKapalAccModel);
  }

  List<DataGridRow> accData = [];
  final controller = Get.put(JadwalKapalAccController());
  int index = 0;

  @override
  List<DataGridRow> get rows => accData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = accData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    // Ambil jadwal kapal berdasarkan rowIndex
    final jadwalKapal = jadwalKapalAccModel[rowIndex];

    List<Widget> cells = [
      ...row.getCells().map<Widget>((e) {
        // print(
        //     'Membuat sel untuk kolom: ${e.columnName} dengan nilai: ${e.value}');
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          child: Text(
            e.value.toString(),
            maxLines: 1,
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
          IconButton(
              onPressed: () {
                if (onLihat != null) {
                  onLihat!(jadwalKapal);
                } else {
                  return;
                }
              },
              icon: const Icon(
                Iconsax.eye,
              ))
        ],
      ));
    }

    if (controller.editRole != 0) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onLihat != null) {
                  onLihat!(jadwalKapal);
                } else {
                  return;
                }
              },
              icon: const Icon(
                Iconsax.edit,
              ))
        ],
      ));
    }

    return DataGridRowAdapter(
      color: (isEvenRow ? Colors.white : Colors.grey[200]),
      cells: cells,
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Tgl Input', value: '-'),
        DataGridCell<String>(columnName: 'Nama Pelayaran', value: '-'),
        DataGridCell<String>(columnName: 'ETD', value: '-'),
        DataGridCell<String>(columnName: 'ATD', value: '-'),
        DataGridCell<String>(columnName: 'Total Unit', value: '-'),
        DataGridCell<String>(columnName: 'Total 20', value: '-'),
        DataGridCell<String>(columnName: 'Total 40', value: '-'),
        DataGridCell<String>(columnName: 'Bongkar Unit', value: '-'),
        DataGridCell<String>(columnName: 'Bongkar 20', value: '-'),
        DataGridCell<String>(columnName: 'Bongkar 40', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<JadwalKapalAccModel> jadwalKapalAccModel) {
    if (jadwalKapalAccModel.isEmpty) {
      accData = _generateEmptyRows(1);
    } else {
      accData = jadwalKapalAccModel.map<DataGridRow>(
        (e) {
          index++;

          final tglInput = CustomHelperFunctions.getFormattedDate(
              DateTime.parse(e.tglInput));
          final etd =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(e.etd));
          final atd =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(e.atd));

          // Cetak semua kolom yang akan digunakan
          final columns = [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Tgl Input', value: tglInput),
            DataGridCell<String>(
                columnName: 'Nama Pelayaran', value: e.namaPelayaran),
            DataGridCell<String>(columnName: 'ETD', value: etd),
            DataGridCell<String>(columnName: 'ATD', value: atd),
            DataGridCell<int>(columnName: 'Total Unit', value: e.totalUnit),
            DataGridCell<int>(columnName: 'Total 20', value: e.feet20),
            DataGridCell<int>(columnName: 'Total 40', value: e.feet40),
            DataGridCell<int>(columnName: 'Bongkar Unit', value: e.bongkarUnit),
            DataGridCell<int>(columnName: 'Bongkar 20', value: e.bonkar20),
            DataGridCell<int>(columnName: 'Bongkar 40', value: e.bongkar40),
          ];

          // Cetak jumlah kolom yang digunakan dalam setiap baris
          return DataGridRow(cells: columns);
        },
      ).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(jadwalKapalAccModel);
    notifyListeners();
    return true;
  }
}
