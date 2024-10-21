import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/laporan/defect_part_model.dart';
import '../../constant/custom_size.dart';

class LaporanDefectTypeSource extends DataGridSource {
  final List<DefectTypeModel> detailDefectModel;
  int startIndex = 0;

  LaporanDefectTypeSource({
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
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'Total Defect', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<DefectTypeModel> detailDefectModel, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;
    if (detailDefectModel.isEmpty) {
      print('Model is empty, generating empty rows');
      detailDefectData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      detailDefectData =
          detailDefectModel.skip(startIndex).take(10).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
            DataGridCell<int>(columnName: 'Total Defect', value: e.total),
          ]);
        },
      ).toList();
    }
    notifyListeners(); // Memberi tahu perubahan data
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(detailDefectModel, startIndex);
    notifyListeners();
    return true;
  }
}

class LaporanDefectPartSource extends DataGridSource {
  final List<DefectPartModel> detailDefectModel;

  LaporanDefectPartSource({
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
        DataGridCell<String>(columnName: 'Part Motor', value: '-'),
        DataGridCell<String>(columnName: 'Total Defect', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<DefectPartModel> detailDefectModel, int startIndex) {
    if (detailDefectModel.isEmpty) {
      print('Model is empty, generating empty rows');
      detailDefectData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      index = 0; // Reset index untuk memastikan data baru diambil dengan benar
      detailDefectData =
          detailDefectModel.skip(startIndex).take(10).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Part Motor', value: e.part),
            DataGridCell<int>(columnName: 'Total Defect', value: e.total),
          ]);
        },
      ).toList();
    }
    notifyListeners(); // Memberi tahu perubahan data
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(detailDefectModel, startIndex);
    notifyListeners();
    return true;
  }
}

// ini all data dari defect type dan part
class LaporanAllDefectTypeSource extends DataGridSource {
  final List<AllDefectTypeModel> detailDefectModel;
  int startIndex = 0;

  LaporanAllDefectTypeSource({
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
        DataGridCell<String>(columnName: 'Type Motor', value: '-'),
        DataGridCell<String>(columnName: 'Total Defect', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<AllDefectTypeModel> detailDefectModel, int startIndex) {
    if (detailDefectModel.isEmpty) {
      print('Model is empty, generating empty rows');
      detailDefectData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      index = startIndex;
      detailDefectData =
          detailDefectModel.skip(startIndex).take(10).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Type Motor', value: e.typeMotor),
            DataGridCell<int>(columnName: 'Total Defect', value: e.total),
          ]);
        },
      ).toList();
    }
    notifyListeners(); // Memberi tahu perubahan data
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(detailDefectModel, startIndex);
    notifyListeners();
    return true;
  }
}

class LaporanAllDefectPartSource extends DataGridSource {
  final List<AllDefectPartModel> detailDefectModel;

  LaporanAllDefectPartSource({
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
        DataGridCell<String>(columnName: 'Part Motor', value: '-'),
        DataGridCell<String>(columnName: 'Total Defect', value: '-'),
      ]);
    });
  }

  void _updateDataPager(
      List<AllDefectPartModel> detailDefectModel, int startIndex) {
    if (detailDefectModel.isEmpty) {
      print('Model is empty, generating empty rows');
      detailDefectData = _generateEmptyRows(1);
    } else {
      print('Model has data, generating rows based on model');
      index = startIndex;
      detailDefectData =
          detailDefectModel.skip(startIndex).take(10).map<DataGridRow>(
        (e) {
          index++;
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: 'No', value: index),
            DataGridCell<String>(columnName: 'Part Motor', value: e.part),
            DataGridCell<int>(columnName: 'Total Defect', value: e.total),
          ]);
        },
      ).toList();
    }
    notifyListeners(); // Memberi tahu perubahan data
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startIndex = newPageIndex * 10;
    _updateDataPager(detailDefectModel, startIndex);
    notifyListeners();
    return true;
  }
}
