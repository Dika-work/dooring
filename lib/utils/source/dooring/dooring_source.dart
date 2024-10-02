import 'package:dooring/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/dooring/dooring_controller.dart';
import '../../../helpers/helper_func.dart';
import '../../../models/dooring/dooring_model.dart';
import '../../constant/custom_size.dart';

class DooringSource extends DataGridSource {
  final void Function(DooringModel)? onLihat;
  final void Function(DooringModel)? onDefect;
  final void Function(DooringModel)? onEdited;
  final List<DooringModel> dooringModel;

  DooringSource({
    required this.onLihat,
    required this.onDefect,
    required this.onEdited,
    required this.dooringModel,
  }) {
    _updateDataPager(dooringModel);
  }

  List<DataGridRow> dooringData = [];
  final controller = Get.put(DooringController());
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

    cells.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              if (onLihat != null && dooringModel.isNotEmpty) {
                onLihat!(dooringModel[rowIndex]);
              } else {
                return;
              }
            },
            icon: const Icon(
              Iconsax.eye,
            ))
      ],
    ));

    if (dooringModel[rowIndex].statusDefect == 0) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onDefect != null && dooringModel.isNotEmpty) {
                  onDefect!(dooringModel[rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(
                Icons.file_copy,
                color: AppColors.buttonPrimary,
              ))
        ],
      ));
    } else if (dooringModel[rowIndex].statusDefect == 1) {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onDefect != null && dooringModel.isNotEmpty) {
                  onDefect!(dooringModel[rowIndex]);
                } else {
                  return;
                }
              },
              icon: const Icon(
                Icons.add,
                color: AppColors.success,
              ))
        ],
      ));
    } else if (dooringModel[rowIndex].statusDefect == 2) {
      cells.add(const Center(child: Text('Selesai')));
    } else if (dooringModel[rowIndex].statusDefect == 3) {
      cells.add(const Center(child: Text('-')));
    } else {
      cells.add(const SizedBox.shrink());
    }

    if (dooringModel[rowIndex].statusDefect == 0) {
      cells.add(const SizedBox.shrink());
    } else {
      cells.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (onEdited != null && dooringModel.isNotEmpty) {
                  onEdited!(dooringModel[rowIndex]);
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
        DataGridCell<String>(columnName: 'Tgl Bongkar', value: '-'),
        DataGridCell<String>(columnName: 'Total Unit', value: '-'),
      ]);
    });
  }

  void _updateDataPager(List<DooringModel> dooringModel) {
    if (dooringModel.isEmpty) {
      print('Model is empty, generating empty rows');
      dooringData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      dooringData = dooringModel.map<DataGridRow>(
        (e) {
          index++;
          final tglInput =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(e.tgl));
          final etd =
              CustomHelperFunctions.getFormattedDate(DateTime.parse(e.etd));
          final tglBongkar = CustomHelperFunctions.getFormattedDate(
              DateTime.parse(e.tglBongkar));
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Tgl Input', value: tglInput),
            DataGridCell<String>(
                columnName: 'Nama Pelayaran', value: e.namaKapal),
            DataGridCell<String>(columnName: 'ETD', value: etd),
            DataGridCell<String>(columnName: 'Tgl Bongkar', value: tglBongkar),
            DataGridCell<int>(columnName: 'Total Unit', value: e.unit),
          ]);
        },
      ).toList();
      notifyListeners();
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(controller.dooringModel);
    notifyListeners();
    return true;
  }
}
