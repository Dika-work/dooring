class DetailDefectModel {
  String namaKapal;
  String wilayah;
  String etd;
  String tglBongkar;
  int unit;
  String helmL;
  String accuL;
  String spionL;
  String buserL;
  String toolSetL;
  String helmK;
  String accuK;
  String spionK;
  String buserK;
  String toolSetK;
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
    required this.helmL,
    required this.accuL,
    required this.spionL,
    required this.buserL,
    required this.toolSetL,
    required this.helmK,
    required this.accuK,
    required this.spionK,
    required this.buserK,
    required this.toolSetK,
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
      helmL: json['helm_l'] ?? 0,
      accuL: json['accu_l'] ?? 0,
      spionL: json['spion_l'] ?? 0,
      buserL: json['buser_l'] ?? 0,
      toolSetL: json['toolset_l'] ?? 0,
      helmK: json['helm_k'] ?? 0,
      accuK: json['accu_k'] ?? 0,
      spionK: json['spion_k'] ?? 0,
      buserK: json['buser_k'] ?? 0,
      toolSetK: json['toolset_k'] ?? 0,
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
