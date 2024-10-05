import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/defect_model.dart';
import '../../../models/dooring/detail_defect_model.dart';
import '../../constant/custom_size.dart';

class LihatDooringSource extends DataGridSource {
  final List<DefectModel> defectModel;

  LihatDooringSource({
    required this.defectModel,
    int startIndex = 0,
  }) {
    _updateDataPager(defectModel, startIndex);
  }

  List<DataGridRow> dooringData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => dooringData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = dooringData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    List<Widget> cells = [
      ...row.getCells().map<Widget>((e) {
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

    return DataGridRowAdapter(
      color: (isEvenRow ? Colors.white : Colors.grey[200]),
      cells: cells,
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'Part Motor', value: '-'),
        DataGridCell<String>(columnName: 'Jml', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<DefectModel> defectModel, int startIndex) {
    if (defectModel.isEmpty) {
      print('Model is empty, generating empty rowszzzz');
      dooringData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      index = startIndex + 1;
      dooringData = defectModel.skip(startIndex).take(5).map<DataGridRow>(
        (e) {
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index++),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
            DataGridCell<String>(columnName: 'Part Motor', value: e.part),
            DataGridCell<int>(columnName: 'Jml', value: e.jumlah),
          ]);
        },
      ).toList();
    }
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 5;
    _updateDataPager(defectModel, startIndex);
    notifyListeners();
    return true;
  }
}

// table yg dibawah lihat dooring

class DetailLihatSource extends DataGridSource {
  final List<DetailDefectModel> defectModel;

  DetailLihatSource({
    required this.defectModel,
    int startIndex = 0,
  }) {
    _updateDataPager(defectModel, startIndex);
  }

  List<DataGridRow> dooringData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => dooringData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = dooringData.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    List<Widget> cells = [
      ...row.getCells().map<Widget>((e) {
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

    return DataGridRowAdapter(
      color: (isEvenRow ? Colors.white : Colors.grey[200]),
      cells: cells,
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'Part Motor', value: '-'),
        DataGridCell<String>(columnName: 'No Mesin', value: '-'),
        DataGridCell<String>(columnName: 'No Rangka', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<DetailDefectModel> defectModel, int startIndex) {
    if (defectModel.isEmpty) {
      print('Model is empty, generating empty rowszzzz');
      dooringData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      index = startIndex + 1;
      dooringData = defectModel.skip(startIndex).take(5).map<DataGridRow>(
        (e) {
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index++),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
            DataGridCell<String>(columnName: 'Part Motor', value: e.part),
            DataGridCell<String>(columnName: 'No Mesin', value: e.noMesin),
            DataGridCell<String>(columnName: 'No Rangka', value: e.noRangka),
          ]);
        },
      ).toList();
    }
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 5;
    _updateDataPager(defectModel, startIndex);
    notifyListeners();
    return true;
  }
}
