import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/kapal_model.dart';
import '../../constant/custom_size.dart';

class TypeMotorSource extends DataGridSource {
  final void Function(TypeMotorModel)? onEdited;
  final void Function(TypeMotorModel)? onDeleted;
  final List<TypeMotorModel> typeMotorModel;

  TypeMotorSource({
    required this.onEdited,
    required this.onDeleted,
    required this.typeMotorModel,
  }) {
    _updateDataPager(typeMotorModel);
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
                if (onEdited != null && typeMotorModel.isNotEmpty) {
                  onEdited!(typeMotorModel[rowIndex]);
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
                if (onDeleted != null && typeMotorModel.isNotEmpty) {
                  onDeleted!(typeMotorModel[rowIndex]);
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
        DataGridCell<String>(columnName: 'Merk', value: '-'),
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<TypeMotorModel> typeMotorModel) {
    if (typeMotorModel.isEmpty) {
      print('Model is empty, generating empty rows');
      dooringData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      dooringData = typeMotorModel.map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Merk', value: e.merk),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
          ]);
        },
      ).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(typeMotorModel);
    notifyListeners();
    return true;
  }
}
