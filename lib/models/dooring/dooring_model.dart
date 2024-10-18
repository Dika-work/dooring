class DooringModel {
  int idDooring;
  String namaKapal;
  String jam;
  String tgl;
  String user;
  String wilayah;
  String etd;
  String atd;
  String tglBongkar;
  int unit;
  String ct20;
  String ct40;
  int helm1;
  int accu1;
  int spion1;
  int buser1;
  int toolset1;
  int helmKurang;
  int accuKurang;
  int spionKurang;
  int buserKurang;
  int totalsetKurang;
  int statusInput;
  int statusDefect;
  int jumlahDefect;
  int jumlahDetail;

  DooringModel({
    required this.idDooring,
    required this.namaKapal,
    required this.jam,
    required this.tgl,
    required this.user,
    required this.wilayah,
    required this.etd,
    required this.atd,
    required this.tglBongkar,
    required this.unit,
    required this.ct20,
    required this.ct40,
    required this.helm1,
    required this.accu1,
    required this.spion1,
    required this.buser1,
    required this.toolset1,
    required this.helmKurang,
    required this.accuKurang,
    required this.spionKurang,
    required this.buserKurang,
    required this.totalsetKurang,
    required this.statusInput,
    required this.statusDefect,
    required this.jumlahDefect,
    required this.jumlahDetail,
  });

  factory DooringModel.fromJson(Map<String, dynamic> json) {
    return DooringModel(
      idDooring: json['id_dooring'] ?? 0,
      namaKapal: json['nm_kapal'] ?? '',
      jam: json['jam'] ?? '',
      tgl: json['tgl'] ?? '',
      user: json['user'] ?? '',
      wilayah: json['wilayah'] ?? '',
      etd: json['etd'] ?? '',
      atd: json['atd'] ?? '',
      tglBongkar: json['tgl_bongkar'] ?? '',
      unit: json['unit'] ?? 0,
      ct20: json['ct_20'] ?? '',
      ct40: json['ct_40'] ?? '',
      helm1: json['helm_l'] ?? 0,
      accu1: json['accu_l'] ?? 0,
      spion1: json['spion_l'] ?? 0,
      buser1: json['buser_l'] ?? 0,
      toolset1: json['toolset_l'] ?? 0,
      helmKurang: json['helm_k'] ?? 0,
      accuKurang: json['accu_k'] ?? 0,
      spionKurang: json['spion_k'] ?? 0,
      buserKurang: json['buser_k'] ?? 0,
      totalsetKurang: json['toolset_k'] ?? 0,
      statusInput: json['st_input'] ?? 0,
      statusDefect: json['st_defect'] ?? 0,
      jumlahDefect: json['jumlah_defect'] ?? 0,
      jumlahDetail: json['jumlah_detail'] ?? 0,
    );
  }
}

// seluruh dooring
class AllDooringModel {
  int idDooring;
  String namaKapal;
  String jam;
  String tgl;
  String user;
  String wilayah;
  String etd;
  String atd;
  String tglBongkar;
  int unit;
  String ct20;
  String ct40;
  int helm1;
  int accu1;
  int spion1;
  int buser1;
  int toolset1;
  int helmKurang;
  int accuKurang;
  int spionKurang;
  int buserKurang;
  int totalsetKurang;
  int statusInput;
  int statusDefect;
  int jumlahDefect;
  int jumlahDetail;

  AllDooringModel({
    required this.idDooring,
    required this.namaKapal,
    required this.jam,
    required this.tgl,
    required this.user,
    required this.wilayah,
    required this.etd,
    required this.atd,
    required this.tglBongkar,
    required this.unit,
    required this.ct20,
    required this.ct40,
    required this.helm1,
    required this.accu1,
    required this.spion1,
    required this.buser1,
    required this.toolset1,
    required this.helmKurang,
    required this.accuKurang,
    required this.spionKurang,
    required this.buserKurang,
    required this.totalsetKurang,
    required this.statusInput,
    required this.statusDefect,
    required this.jumlahDefect,
    required this.jumlahDetail,
  });

  factory AllDooringModel.fromJson(Map<String, dynamic> json) {
    return AllDooringModel(
      idDooring: json['id_dooring'] ?? 0,
      namaKapal: json['nm_kapal'] ?? '',
      jam: json['jam'] ?? '',
      tgl: json['tgl'] ?? '',
      user: json['user'] ?? '',
      wilayah: json['wilayah'] ?? '',
      etd: json['etd'] ?? '',
      atd: json['atd'] ?? '',
      tglBongkar: json['tgl_bongkar'] ?? '',
      unit: json['unit'] ?? 0,
      ct20: json['ct_20'] ?? '',
      ct40: json['ct_40'] ?? '',
      helm1: json['helm_l'] ?? 0,
      accu1: json['accu_l'] ?? 0,
      spion1: json['spion_l'] ?? 0,
      buser1: json['buser_l'] ?? 0,
      toolset1: json['toolset_l'] ?? 0,
      helmKurang: json['helm_k'] ?? 0,
      accuKurang: json['accu_k'] ?? 0,
      spionKurang: json['spion_k'] ?? 0,
      buserKurang: json['buser_k'] ?? 0,
      totalsetKurang: json['toolset_k'] ?? 0,
      statusInput: json['st_input'] ?? 0,
      statusDefect: json['st_defect'] ?? 0,
      jumlahDefect: json['jumlah_defect'] ?? 0,
      jumlahDetail: json['jumlah_detail'] ?? 0,
    );
  }
}
