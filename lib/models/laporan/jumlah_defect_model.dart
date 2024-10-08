class JumlahDefectModel {
  int bulan;
  int tahun;
  String wilayah;
  int totalJumlah;

  JumlahDefectModel(
      {required this.bulan,
      required this.tahun,
      required this.wilayah,
      required this.totalJumlah});

  factory JumlahDefectModel.fromJson(Map<String, dynamic> json) {
    return JumlahDefectModel(
        bulan: json['bulan'] ?? 0,
        tahun: json['tahun'] ?? 0,
        wilayah: json['wilayah'] ?? '',
        totalJumlah: json['total_jumlah'] ?? 0);
  }
}
