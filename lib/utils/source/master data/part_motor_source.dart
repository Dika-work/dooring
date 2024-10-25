import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/kapal_model.dart';
import '../../constant/custom_size.dart';

class PartMotorSource extends DataGridSource {
  final void Function(PartMotorModel)? onEdited;
  final List<PartMotorModel> partMotorModel;

  PartMotorSource({
    required this.onEdited,
    required this.partMotorModel,
  }) {
    _updateDataPager(partMotorModel);
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
                if (onEdited != null && partMotorModel.isNotEmpty) {
                  onEdited!(partMotorModel[rowIndex]);
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

  void _updateDataPager(List<PartMotorModel> partMotorModel) {
    wilayahData = partMotorModel.map<DataGridRow>(
      (e) {
        index++;
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Nama Part', value: e.namaPart),
        ]);
      },
    ).toList();
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(partMotorModel);
    notifyListeners();
    return true;
  }
}
