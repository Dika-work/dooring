class DooringModel {
  int idDooring;
  String namaKapal;
  String jam;
  String tgl;
  String user;
  String wilayah;
  String etd;
  String tglBongkar;
  int unit;
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

  DooringModel({
    required this.idDooring,
    required this.namaKapal,
    required this.jam,
    required this.tgl,
    required this.user,
    required this.wilayah,
    required this.etd,
    required this.tglBongkar,
    required this.unit,
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
      tglBongkar: json['tgl_bongkar'] ?? '',
      unit: json['unit'] ?? 0,
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
    );
  }
}
