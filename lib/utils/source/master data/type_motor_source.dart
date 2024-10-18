import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/dooring/kapal_model.dart';
import '../../constant/custom_size.dart';

class TypeMotorSource extends DataGridSource {
  final void Function(TypeMotorModel)? onEdited;
  final void Function(TypeMotorModel)? onDeleted;
  final List<TypeMotorModel> typeMotorModel;
  final BuildContext context;

  TypeMotorSource({
    required this.onEdited,
    required this.onDeleted,
    required this.typeMotorModel,
    required this.context,
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

    List<Widget> cells = row.getCells().map<Widget>((e) {
      if (e.columnName == 'Type Motor') {
        // Wrap the "Type Motor" cell with a GestureDetector for long press tooltip
        return GestureDetector(
          onLongPressStart: (details) {
            _showOverlay(details.globalPosition, e.value.toString());
          },
          onLongPressEnd: (details) {
            _removeOverlay();
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Text(
              e.value.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: CustomSize.fontSizeXm,
              ),
            ),
          ),
        );
      } else {
        // Default rendering for other cells
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          child: Text(
            e.value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: CustomSize.fontSizeXm,
            ),
          ),
        );
      }
    }).toList();

    // Add edit and delete buttons
    cells.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (onEdited != null && typeMotorModel.isNotEmpty) {
                onEdited!(typeMotorModel[rowIndex]);
              }
            },
            icon: const Icon(Iconsax.grid_edit),
          ),
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
              }
            },
            icon: const Icon(Iconsax.trash, color: Colors.red),
          ),
        ],
      ),
    );

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }

  OverlayEntry? _overlayEntry;

  void _showOverlay(Offset position, String text) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy - 30, // Position above the long-pressed cell
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
      dooringData = _generateEmptyRows(1);
    } else {
      index = 0;
      dooringData = typeMotorModel.map<DataGridRow>((e) {
        index++;
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Merk', value: e.merk),
          DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
        ]);
      }).toList();
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
