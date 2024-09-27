import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/kapal_model.dart';
import '../../constant/custom_size.dart';

class WilayahSource extends DataGridSource {
  final void Function(WilayahModel)? onEdited;
  final List<WilayahModel> wilayahModel;

  WilayahSource({
    required this.onEdited,
    required this.wilayahModel,
  }) {
    _updateDataPager(wilayahModel);
  }

  List<DataGridRow> wilayahData = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => wilayahData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = wilayahData.indexOf(row);
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

    cells.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onEdited != null && wilayahModel.isNotEmpty) {
                  onEdited!(wilayahModel[rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.grid_edit)),
        ],
      ),
    );

    return DataGridRowAdapter(
      color: (isEvenRow ? Colors.white : Colors.grey[200]),
      cells: cells,
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Nama Wilayah', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<WilayahModel> wilayahModel) {
    if (wilayahModel.isEmpty) {
      print('Model is empty, generating empty rows');
      wilayahData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      wilayahData = wilayahModel.map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Nama Wilayah', value: e.wilayah),
          ]);
        },
      ).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(wilayahModel);
    notifyListeners();
    return true;
  }
}
