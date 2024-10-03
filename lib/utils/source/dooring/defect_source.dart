import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/defect_model.dart';
import '../../constant/custom_size.dart';

class DefectSource extends DataGridSource {
  final void Function(DefectModel)? onLihat;
  final void Function(DefectModel)? onEdited;
  final void Function(DefectModel)? onAdded;
  final void Function(DefectModel)? onDeleted;
  final List<DefectModel> defectModel;
  int startIndex = 0;

  DefectSource({
    required this.onLihat,
    required this.onEdited,
    required this.onAdded,
    required this.onDeleted,
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

    final bool statusDetail = defectModel[rowIndex].status > 0;

    if (statusDetail) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onLihat != null) {
                  onLihat!(defectModel[rowIndex]);
                }
              },
              icon: const Icon(
                Iconsax.eye,
              ))
        ],
      ));
    } else {
      cells.add(const Center(child: Text('-')));
    }

    if (!statusDetail) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onAdded != null) {
                  onAdded!(defectModel[rowIndex]);
                }
              },
              icon: const Icon(
                Iconsax.add,
              ))
        ],
      ));
    } else {
      cells.add(const Center(child: Text('-')));
    }

    if (!statusDetail) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onEdited != null) {
                  onEdited!(defectModel[rowIndex]);
                }
              },
              icon: const Icon(
                Iconsax.edit,
              ))
        ],
      ));
    } else {
      cells.add(const Center(child: Text('-')));
    }

    if (!statusDetail) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onDeleted != null) {
                  onDeleted!(defectModel[rowIndex]);
                }
              },
              icon: const Icon(
                Iconsax.trash,
              ))
        ],
      ));
    } else {
      cells.add(const Center(child: Text('-')));
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
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'Part Motor', value: '-'),
        DataGridCell<String>(columnName: 'Jml', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<DefectModel> defectModel, int startIndex) {
    if (defectModel.isEmpty) {
      print('Model is empty, generating empty rows');
      dooringData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      dooringData = defectModel.skip(startIndex).take(5).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
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
    _updateDataPager(defectModel, newPageIndex);
    notifyListeners();
    return true;
  }
}
