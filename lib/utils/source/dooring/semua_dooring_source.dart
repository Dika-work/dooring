import 'package:dooring/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/dooring/dooring_controller.dart';
import '../../../helpers/helper_func.dart';
import '../../../models/dooring/dooring_model.dart';
import '../../constant/custom_size.dart';

class SemuaDooringSource extends DataGridSource {
  final void Function(AllDooringModel)? onLihat;
  final void Function(AllDooringModel)? onDefect;
  final void Function(AllDooringModel)? onEdited;
  final List<AllDooringModel> dooringModel;
  final bool isAdmin;

  SemuaDooringSource({
    required this.onLihat,
    required this.onDefect,
    required this.onEdited,
    required this.dooringModel,
    required this.isAdmin,
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

    if (controller.lihatRole != 0) {
      if (dooringModel[rowIndex].statusDefect == 2) {
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
      } else {
        cells.add(const Center(child: Text('-')));
      }
    }

    if (controller.tambahRole != 0) {
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
      } else if (dooringModel[rowIndex].statusDefect == 1 &&
          controller.tambahRole != 0) {
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
      } else if (dooringModel[rowIndex].statusDefect == 2 &&
          controller.tambahRole != 0) {
        cells.add(const Center(child: Text('Selesai')));
      } else if (dooringModel[rowIndex].statusDefect == 3 &&
          controller.tambahRole != 0) {
        cells.add(const Center(child: Text('-')));
      } else {
        cells.add(const SizedBox.shrink());
      }
    }

    if (controller.editRole != 0) {
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
    }

    return DataGridRowAdapter(
      color: (isEvenRow ? Colors.white : Colors.grey[200]),
      cells: cells,
    );
  }

  Map<String, String> regionMapping = {
    'SAMARINDA': 'SRD',
    'MAKASSAR': 'MKS',
    'PONTIANAK': 'PTK',
    'BANJARMASIN': 'BJM'
  };

  void _updateDataPager(List<AllDooringModel> dooringModel) {
    final filteredData = isAdmin
        ? dooringModel
        : dooringModel
            .where((item) => item.wilayah == controller.roleWilayah)
            .toList();

    dooringData = filteredData.map<DataGridRow>(
      (e) {
        index++;
        // Mencari singkatan wilayah terlebih dahulu
        final regionKey = regionMapping.keys.firstWhere(
          (region) => e.wilayah.contains(region),
          orElse: () => e.wilayah,
        );

        // Mendapatkan nama wilayah lengkap dari regionMapping
        final regionValue = regionMapping[regionKey] ?? e.wilayah;

        print('ini region value : $regionValue');

        final tglInput =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(e.tgl));
        final etd =
            CustomHelperFunctions.getFormattedDate(DateTime.parse(e.etd));
        final tglBongkar = CustomHelperFunctions.getFormattedDate(
            DateTime.parse(e.tglBongkar));
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          if (controller.isAdmin)
            DataGridCell<String>(columnName: 'Wilayah', value: regionValue),
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

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _updateDataPager(controller.allDooringModel);
    notifyListeners();
    return true;
  }
}
