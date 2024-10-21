class JadwalKapalAccModel {
  int idJadwalAcc;
  String tglInput;
  String namaPelayaran;
  String etd;
  String atd;
  int totalUnit;
  int feet20;
  int feet40;
  int bongkarUnit;
  int bonkar20;
  int bongkar40;

  JadwalKapalAccModel({
    required this.idJadwalAcc,
    required this.tglInput,
    required this.namaPelayaran,
    required this.etd,
    required this.atd,
    required this.totalUnit,
    required this.feet20,
    required this.feet40,
    required this.bongkarUnit,
    required this.bonkar20,
    required this.bongkar40,
  });

  factory JadwalKapalAccModel.fromJson(Map<String, dynamic> json) {
    return JadwalKapalAccModel(
        idJadwalAcc: json['id_jadwal_acc'],
        tglInput: json['tgl_input'],
        namaPelayaran: json['nm_pelayaran'],
        etd: json['etd'],
        atd: json['atd'],
        totalUnit: json['total_unit'],
        feet20: json['feet_20'],
        feet40: json['feet_40'],
        bongkarUnit: json['bongkar_unit'],
        bonkar20: json['bongkar_20'],
        bongkar40: json['bongkar_40']);
  }
}
