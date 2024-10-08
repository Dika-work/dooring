import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan/jumlah_defect_model.dart';

class JumlahDefectSource extends DataGridSource {
  final int selectedYear;
  final List<JumlahDefectModel> jumlahDefectModel;

  JumlahDefectSource({
    required this.selectedYear,
    required this.jumlahDefectModel,
  }) {
    _buildData();
  }

  List<DataGridRow> totalData = [];

  void _buildData() {
    const int numberOfMonths = 12;
    Map<int, int> samarindaResults = {};
    Map<int, int> makassarResults = {};
    Map<int, int> pontianakResults = {};
    Map<int, int> banjarMasinResults = {};

    for (var data in jumlahDefectModel) {
      if (data.wilayah == "SAMARINDA") {
        samarindaResults[data.bulan] = data.totalJumlah;
      } else if (data.wilayah == "MAKASSAR") {
        makassarResults[data.bulan] = data.totalJumlah;
      } else if (data.wilayah == "PONTIANAK") {
        pontianakResults[data.bulan] = data.totalJumlah;
      } else if (data.wilayah == "BANJARMASIN") {
        banjarMasinResults[data.bulan] = data.totalJumlah;
      }
    }

    // Total Unit row
    List<DataGridCell> srdCells = [
      const DataGridCell<String>(columnName: 'Wilayah', value: 'SAMARINDA'),
    ];

    List<DataGridCell> mksCells = [
      const DataGridCell<String>(columnName: 'Wilayah', value: 'MAKASSAR'),
    ];

    List<DataGridCell> ptkCells = [
      const DataGridCell<String>(columnName: 'Wilayah', value: 'PONTIANAK'),
    ];

    List<DataGridCell> bjmCells = [
      const DataGridCell<String>(columnName: 'Wilayah', value: 'BANJARMASIN'),
    ];

    int totalSrd = 0;
    int totalMks = 0;
    int totalPtk = 0;
    int totalBjm = 0;

    for (int i = 1; i <= numberOfMonths; i++) {
      // Mengisi nilai SAMARINDA
      int srdResult = samarindaResults[i] ?? 0; // Pastikan default 0
      srdCells.add(DataGridCell<int>(columnName: 'Bulan $i', value: srdResult));
      totalSrd += srdResult;

      // Mengisi nilai MAKASSAR
      int mksResult = makassarResults[i] ?? 0; // Pastikan default 0
      mksCells.add(DataGridCell<int>(columnName: 'Bulan $i', value: mksResult));
      totalMks += mksResult;

      // Mengisi nilai PONTIANAK
      int ptkResult = pontianakResults[i] ?? 0; // Pastikan default 0
      ptkCells.add(DataGridCell<int>(columnName: 'Bulan $i', value: ptkResult));
      totalPtk += ptkResult;

      // Mengisi nilai BANJARMASIN
      int bjmResult = banjarMasinResults[i] ?? 0; // Pastikan default 0
      bjmCells.add(DataGridCell<int>(columnName: 'Bulan $i', value: bjmResult));
      totalBjm += bjmResult;
    }

    // Tambahkan total di akhir
    srdCells.add(DataGridCell<int>(columnName: 'TOTAL', value: totalSrd));
    mksCells.add(DataGridCell<int>(columnName: 'TOTAL', value: totalMks));
    ptkCells.add(DataGridCell<int>(columnName: 'TOTAL', value: totalPtk));
    bjmCells.add(DataGridCell<int>(columnName: 'TOTAL', value: totalBjm));

    totalData.add(DataGridRow(cells: srdCells));
    totalData.add(DataGridRow(cells: mksCells));
    totalData.add(DataGridRow(cells: ptkCells));
    totalData.add(DataGridRow(cells: bjmCells));
  }

  @override
  List<DataGridRow> get rows => totalData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataGridCell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}
