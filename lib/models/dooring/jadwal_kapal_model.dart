class JadwalKapalModel {
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
  int ct20Dooring;
  int ct40Dooring;
  int unitDooring;
  int totalDooring;
  int totalStatusDefect;

  JadwalKapalModel({
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
    required this.ct20Dooring,
    required this.ct40Dooring,
    required this.unitDooring,
    required this.totalDooring,
    required this.totalStatusDefect,
  });

  factory JadwalKapalModel.fromJson(Map<String, dynamic> json) {
    return JadwalKapalModel(
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
      ct20Dooring: json['ct20_dooring'] ?? 0,
      ct40Dooring: json['ct40_dooring'] ?? 0,
      unitDooring: json['unit_dooring'] ?? 0,
      totalDooring: json['total_dooring'] ?? 0,
      totalStatusDefect: json['total_st_defect'] ?? 0,
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

// class SeluruhJadwalKapal {
//   int idDooring;
//   String idJadwal;
//   String namaKapal;
//   String jam;
//   String tgl;
//   String user;
//   String wilayah;
//   String etd;
//   String atd;
//   String tglBongkar;
//   int unit;
//   String ct20;
//   String ct40;
//   int helmL;
//   int accuL;
//   int spionL;
//   int buserL;
//   int toolSetL;
//   int helmK;
//   int accuK;
//   int spionK;
//   int buserK;
//   int toolSetK;
//   int stInput;
//   int stDefect;
//   int jumlahDefect;
//   int jumlahDetail;
//   String ct20Dooring;
//   String ct40Dooring;
//   String unitDooring;
//   String ct20Sisa;
//   String ct40Sisa;
//   String unitSisa;

//   SeluruhJadwalKapal({
//     required this.idDooring,
//     required this.idJadwal,
//     required this.namaKapal,
//     required this.jam,
//     required this.tgl,
//     required this.user,
//     required this.wilayah,
//     required this.etd,
//     required this.atd,
//     required this.tglBongkar,
//     required this.unit,
//     required this.ct20,
//     required this.ct40,
//     required this.helmL,
//     required this.accuL,
//     required this.spionL,
//     required this.buserL,
//     required this.toolSetL,
//     required this.helmK,
//     required this.accuK,
//     required this.spionK,
//     required this.buserK,
//     required this.toolSetK,
//     required this.stInput,
//     required this.stDefect,
//     required this.jumlahDefect,
//     required this.jumlahDetail,
//     required this.ct20Dooring,
//     required this.ct40Dooring,
//     required this.unitDooring,
//     required this.ct20Sisa,
//     required this.ct40Sisa,
//     required this.unitSisa,
//   });

//   factory SeluruhJadwalKapal.fromJson(Map<String, dynamic> json) {
//     return SeluruhJadwalKapal(
//       idDooring: json['id_dooring'] ?? 0,
//       idJadwal: json['id_jadwal'] ?? '',
//       namaKapal: json['nm_kapal'] ?? '',
//       jam: json['jam'] ?? '',
//       tgl: json['tgl'] ?? '',
//       user: json['user'] ?? '',
//       wilayah: json['wilayah'] ?? '',
//       etd: json['etd'] ?? '',
//       atd: json['atd'] ?? 0,
//       tglBongkar: json['tgl_bongkar'] ?? 0,
//       unit: json['unit'] ?? 0,
//       ct20: json['ct_20'] ?? 0,
//       ct40: json['ct_40'] ?? '',
//       helmL: json['helm_l'] ?? '',
//       accuL: json['accu_l'] ?? '',
//       spionL: json['spion_l'] ?? 0,
//       buserL: json['buser_l'] ?? 0,
//       toolSetL: json['toolset_l'] ?? 0,
//       helmK: json['helm_k'] ?? 0,
//       accuK: json['accu_k'] ?? 0,
//       spionK: json['spion_k'] ?? 0,
//       buserK: json['buser_k'] ?? 0,
//       toolSetK: json['toolset_k'] ?? 0,
//       stInput: json['st_input'] ?? 0,
//       stDefect: json['st_defect'] ?? 0,
//       jumlahDefect: json['jumlah_defect'],
//       jumlahDetail: json['jumlah_detail'],
//       ct20Dooring: json['ct20_dooring'] ?? 0,
//       ct40Dooring: json['ct40_dooring'],
//       unitDooring: json['unit_dooring'],
//       ct20Sisa: json['ct20_sisa'],
//       ct40Sisa: json['ct40_sisa'],
//       unitSisa: json['unit_sisa'],
//     );
//   }
// }
