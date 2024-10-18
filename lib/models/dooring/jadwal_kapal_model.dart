class JadwalKapalModel {
  int idJadwal;
  String jam;
  String tgl;
  String user;
  String namaKapal;
  String wilayah;
  String tglBongkar;
  int unit;
  int helmL;
  int accuL;
  int spionL;
  int buserL;
  int toolsetL;
  String typeMotor;
  String part;
  int jumlah;
  int statusDetail;
  int jumlahInput;
  String noMesin;
  String noRangka;
  String etd;
  String atd;
  int totalUnit;
  int feet20;
  int feet40;
  int statusJadwal;
  String jamAcc;
  String tglAcc;
  String userAcc;
  int ct20Dooring;
  int ct40Dooring;
  int unitDooring;

  JadwalKapalModel({
    required this.idJadwal,
    required this.jam,
    required this.tgl,
    required this.user,
    required this.namaKapal,
    required this.wilayah,
    required this.tglBongkar,
    required this.unit,
    required this.helmL,
    required this.accuL,
    required this.spionL,
    required this.buserL,
    required this.toolsetL,
    required this.typeMotor,
    required this.part,
    required this.jumlah,
    required this.statusDetail,
    required this.jumlahInput,
    required this.noMesin,
    required this.noRangka,
    required this.etd,
    required this.atd,
    required this.totalUnit,
    required this.feet20,
    required this.feet40,
    required this.statusJadwal,
    required this.jamAcc,
    required this.tglAcc,
    required this.userAcc,
    required this.ct20Dooring,
    required this.ct40Dooring,
    required this.unitDooring,
  });

  factory JadwalKapalModel.fromJson(Map<String, dynamic> json) {
    return JadwalKapalModel(
      idJadwal: json['id_jadwal'] ?? 0,
      jam: json['jam'] ?? '',
      tgl: json['tgl'] ?? '',
      user: json['user'] ?? '',
      namaKapal: json['nm_kapal'] ?? '',
      wilayah: json['wilayah'] ?? '',
      tglBongkar: json['tgl_bongkar'] ?? '',
      unit: json['unit'] ?? 0,
      helmL: json['helm_l'] ?? 0,
      accuL: json['accu_l'] ?? 0,
      spionL: json['spion_l'] ?? 0,
      buserL: json['buser_l'] ?? 0,
      toolsetL: json['toolset_l'] ?? 0,
      typeMotor: json['type_motor'] ?? '',
      part: json['part'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      statusDetail: json['st_detail'] ?? 0,
      jumlahInput: json['jumlah_input'] ?? 0,
      noMesin: json['no_mesin'] ?? '',
      noRangka: json['no_rangka'] ?? '',
      etd: json['etd'] ?? '',
      atd: json['atd'] ?? '',
      totalUnit: json['total_unit'] ?? 0,
      feet20: json['feet_20'] ?? 0,
      feet40: json['feet_40'] ?? 0,
      statusJadwal: json['st_jadwal'] ?? 0,
      jamAcc: json['jam_acc'] ?? '',
      tglAcc: json['tgl_acc'] ?? '',
      userAcc: json['user_acc'] ?? '',
      ct20Dooring: json['ct20_dooring'] ?? 0,
      ct40Dooring: json['ct40_dooring'] ?? 0,
      unitDooring: json['unit_dooring'] ?? 0,
    );
  }
}

class LihatJadwalKapalModel {
  int idJadwal;
  String jam;
  String tgl;
  String user;
  String namaKapal;
  String wilayah;
  String etd;
  String atd;
  int totalUnit;
  int feet20;
  int feet40;
  int statusJadwal;
  String jamAcc;
  String tglAcc;
  String userAcc;
  int helmL;
  int accuL;
  int spionL;
  int buserL;
  int toolsetL;
  int hasilHelmL;
  int hasilAccuL;
  int hasilSpionL;
  int hasilBuserL;
  int hasilToolSetL;
  String? typeMotor;
  String? part;
  int jumlah;
  int? idDetail;
  String? noMesin;
  String? noRangka;
  String? noCt;

  LihatJadwalKapalModel({
    required this.idJadwal,
    required this.jam,
    required this.tgl,
    required this.user,
    required this.namaKapal,
    required this.wilayah,
    required this.etd,
    required this.atd,
    required this.totalUnit,
    required this.feet20,
    required this.feet40,
    required this.statusJadwal,
    required this.jamAcc,
    required this.tglAcc,
    required this.userAcc,
    required this.helmL,
    required this.accuL,
    required this.spionL,
    required this.buserL,
    required this.toolsetL,
    required this.hasilHelmL,
    required this.hasilAccuL,
    required this.hasilSpionL,
    required this.hasilBuserL,
    required this.hasilToolSetL,
    this.typeMotor,
    this.part,
    required this.jumlah,
    this.idDetail,
    this.noMesin,
    this.noRangka,
    this.noCt,
  });

  factory LihatJadwalKapalModel.fromJson(Map<String, dynamic> json) {
    return LihatJadwalKapalModel(
      idJadwal: json['id_jadwal'] ?? 0,
      jam: json['jam'] ?? '',
      tgl: json['tgl'] ?? '',
      user: json['user'] ?? '',
      namaKapal: json['nm_kapal'] ?? '',
      wilayah: json['wilayah'] ?? '',
      etd: json['etd'] ?? '',
      atd: json['atd'] ?? '',
      totalUnit: json['total_unit'] ?? 0,
      feet20: json['feet_20'] ?? 0,
      feet40: json['feet_40'] ?? 0,
      statusJadwal: json['st_jadwal'] ?? 0,
      jamAcc: json['jam_acc'] ?? '',
      tglAcc: json['tgl_acc'] ?? '',
      userAcc: json['user_acc'] ?? '',
      helmL: json['helm_l'] ?? 0,
      accuL: json['accu_l'] ?? 0,
      spionL: json['spion_l'] ?? 0,
      buserL: json['buser_l'] ?? 0,
      toolsetL: json['toolset_l'] ?? 0,
      hasilHelmL: json['hasil_helm_l'] ?? 0,
      hasilAccuL: json['hasil_accu_l'] ?? 0,
      hasilSpionL: json['hasil_spion_l'] ?? 0,
      hasilBuserL: json['hasil_buser_l'] ?? 0,
      hasilToolSetL: json['hasil_toolset_l'] ?? 0,
      typeMotor: json['type_motor'],
      part: json['part'],
      jumlah: json['jumlah'] ?? 0,
      idDetail: json['id_detail'],
      noMesin: json['no_mesin'],
      noRangka: json['no_rangka'],
      noCt: json['no_ct'],
    );
  }
}
