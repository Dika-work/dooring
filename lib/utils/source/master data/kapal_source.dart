import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/kapal_model.dart';
import '../../constant/custom_size.dart';

class KapalSource extends DataGridSource {
  final void Function(KapalModel)? onEdited;
  final void Function(KapalModel)? onDeleted;
  final List<KapalModel> kapalModel;

  KapalSource({
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

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(count, (index) {
      return const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: '-'),
        DataGridCell<String>(columnName: 'Nama Pelayaran', value: '-'),
        DataGridCell<String>(columnName: 'Nama Kapal', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<KapalModel> kapalModel) {
    if (kapalModel.isEmpty) {
      print('Model is empty, generating empty rows');
      dooringData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      dooringData = kapalModel.map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(
                columnName: 'Nama Pelayaran', value: e.namaPelayaran),
            DataGridCell<String>(columnName: 'Nama Kapal', value: e.namaKapal),
          ]);
        },
      ).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(kapalModel);
    notifyListeners();
    return true;
  }
}
