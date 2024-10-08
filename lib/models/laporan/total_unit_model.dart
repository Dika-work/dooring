class TotalUnitModel {
  int bulan;
  int tahun;
  String wilayah;
  int totalUnit;

  TotalUnitModel(
      {required this.bulan,
      required this.tahun,
      required this.wilayah,
      required this.totalUnit});

  factory TotalUnitModel.fromJson(Map<String, dynamic> json) {
    return TotalUnitModel(
        bulan: json['bulan'] ?? 0,
        tahun: json['tahun'] ?? 0,
        wilayah: json['wilayah'] ?? '',
        totalUnit: json['total_unit'] ?? 0);
  }
}
