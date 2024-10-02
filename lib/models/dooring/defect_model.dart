class DefectModel {
  int idDefect;
  int idDooring;
  String jam;
  String tgl;
  String user;
  String typeMotor;
  String part;
  int jumlah;
  int status;
  String namaKapal;
  String wilayah;
  String etd;
  String tglBongkar;
  int unit;
  int jumlahInput;

  DefectModel({
    required this.idDefect,
    required this.idDooring,
    required this.jam,
    required this.tgl,
    required this.user,
    required this.typeMotor,
    required this.part,
    required this.jumlah,
    required this.status,
    required this.namaKapal,
    required this.wilayah,
    required this.etd,
    required this.tglBongkar,
    required this.unit,
    required this.jumlahInput,
  });

  factory DefectModel.fromJson(Map<String, dynamic> json) {
    return DefectModel(
      idDefect: json['id_defect'] ?? 0,
      idDooring: json['id_dooring'] ?? 0,
      jam: json['jam'] ?? '',
      tgl: json['tgl'] ?? '',
      user: json['user'] ?? '',
      typeMotor: json['type_motor'] ?? '',
      part: json['part'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      status: json['st_detail'] ?? 0,
      namaKapal: json['nm_kapal'] ?? '',
      wilayah: json['wilayah'] ?? '',
      etd: json['etd'] ?? '',
      tglBongkar: json['tgl_bongkar'] ?? '',
      unit: json['unit'] ?? 0,
      jumlahInput: json['jumlah_input'] ?? 0,
    );
  }
}
