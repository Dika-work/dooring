import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/kapal_model.dart';
import '../../constant/custom_size.dart';

class PelayaranSource extends DataGridSource {
  final void Function(PelayaranModel)? onEdited;
  final void Function(PelayaranModel)? onDeleted;
  final List<PelayaranModel> kapalModel;

  PelayaranSource({
    required this.onEdited,
    required this.onDeleted,
    required this.kapalModel,
  }) {
    _updateDataPager(kapalModel);
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

    cells.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onEdited != null && kapalModel.isNotEmpty) {
                  onEdited!(kapalModel[rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.grid_edit)),
        ],
      ),
    );

    cells.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onDeleted != null && kapalModel.isNotEmpty) {
                  onDeleted!(kapalModel[rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(Iconsax.trash, color: Colors.red))
        ],
      ),
    );

    return DataGridRowAdapter(
      color: (isEvenRow ? Colors.white : Colors.grey[200]),
      cells: cells,
    );
  }

  void _updateDataPager(List<PelayaranModel> kapalModel) {
    dooringData = kapalModel.map<DataGridRow>(
      (e) {
        index++;
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Nama Kapal', value: e.namaPel),
        ]);
      },
    ).toList();
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(kapalModel);
    notifyListeners();
    return true;
  }
}
