import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/detail_defect_model.dart';
import '../../constant/custom_size.dart';

class LihatDefectSource extends DataGridSource {
  final List<DetailDefectModel> detailDefectModel;

  LihatDefectSource({
    required this.detailDefectModel,
    int startIndex = 0,
  }) {
    _updateDataPager(detailDefectModel, startIndex);
  }

  List<DataGridRow> detailDefectData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => detailDefectData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = detailDefectData.indexOf(row);
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
        DataGridCell<String>(columnName: 'No Mesin', value: '-'),
        DataGridCell<String>(columnName: 'No Rangka', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<DetailDefectModel> detailDefectModel, int startIndex) {
    if (detailDefectModel.first.jumlahInput == 0) {
      print('Model is empty, generating empty rows');
      detailDefectData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      index = 0; // Reset index untuk memastikan data baru diambil dengan benar
      detailDefectData =
          detailDefectModel.skip(startIndex).take(5).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'No Mesin', value: e.noMesin),
            DataGridCell<String>(columnName: 'No Rangka', value: e.noRangka),
          ]);
        },
      ).toList();
    }
    notifyListeners(); // Memberi tahu perubahan data
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(detailDefectModel, newPageIndex);
    notifyListeners();
    return true;
  }
}
