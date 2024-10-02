class DetailDefectModel {
  String namaKapal;
  String wilayah;
  String etd;
  String tglBongkar;
  int unit;
  int idDefect;
  int idDooring;
  String jam;
  String tgl;
  String user;
  String typeMotor;
  String part;
  int jumlah;
  int statusDetail;
  int jumlahInput;
  int idDetail;
  String noMesin;
  String noRangka;

  DetailDefectModel({
    required this.namaKapal,
    required this.wilayah,
    required this.etd,
    required this.tglBongkar,
    required this.unit,
    required this.idDefect,
    required this.idDooring,
    required this.jam,
    required this.tgl,
    required this.user,
    required this.typeMotor,
    required this.part,
    required this.jumlah,
    required this.statusDetail,
    required this.jumlahInput,
    required this.idDetail,
    required this.noMesin,
    required this.noRangka,
  });

  factory DetailDefectModel.fromJson(Map<String, dynamic> json) {
    return DetailDefectModel(
      namaKapal: json['nm_kapal'] ?? '',
      wilayah: json['wilayah'] ?? '',
      etd: json['etd'] ?? '',
      tglBongkar: json['tgl_bongkar'] ?? '',
      unit: json['unit'] ?? 0,
      idDefect: json['id_defect'] ?? 0,
      idDooring: json['id_dooring'] ?? 0,
      jam: json['jam'] ?? '',
      tgl: json['tgl'] ?? '',
      user: json['user'] ?? '',
      typeMotor: json['type_motor'] ?? '',
      part: json['part'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      statusDetail: json['st_detail'] ?? 0,
      jumlahInput: json['jumlah_input'] ?? 0,
      idDetail: json['id_detail'] ?? 0,
      noMesin: json['no_mesin'] ?? '',
      noRangka: json['no_rangka'] ?? '',
    );
  }
}
