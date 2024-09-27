class DefectModel {
  int idDefect;
  int idDooring;
  String jam;
  String tgl;
  String user;
  String typeMotor;
  String part;
  int jumlah;
  String status;

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
      status: json['status'] ?? '',
    );
  }
}
