class DefectPartModel {
  int bulan;
  int tahun;
  String wilayah;
  String typeMotor;
  String part;
  int total;

  DefectPartModel({
    required this.bulan,
    required this.tahun,
    required this.wilayah,
    required this.typeMotor,
    required this.part,
    required this.total,
  });

  factory DefectPartModel.fromJson(Map<String, dynamic> json) {
    return DefectPartModel(
      bulan: json['bulan'] ?? 0,
      tahun: json['tahun'] ?? 0,
      wilayah: json['wilayah'] ?? '',
      typeMotor: json['type_motor'] ?? '',
      part: json['part'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class DefectTypeModel {
  int bulan;
  int tahun;
  String wilayah;
  String typeMotor;
  String part;
  int total;

  DefectTypeModel({
    required this.bulan,
    required this.tahun,
    required this.wilayah,
    required this.typeMotor,
    required this.part,
    required this.total,
  });

  factory DefectTypeModel.fromJson(Map<String, dynamic> json) {
    return DefectTypeModel(
      bulan: json['bulan'] ?? 0,
      tahun: json['tahun'] ?? 0,
      wilayah: json['wilayah'] ?? '',
      typeMotor: json['type_motor'] ?? '',
      part: json['part'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}
