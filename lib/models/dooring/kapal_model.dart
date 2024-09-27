class KapalModel {
  int idPelayaran;
  String namaKapal;
  String namaPelayaran;

  KapalModel({
    required this.idPelayaran,
    required this.namaKapal,
    required this.namaPelayaran,
  });

  factory KapalModel.fromJson(Map<String, dynamic> json) {
    return KapalModel(
      idPelayaran: json['id_pel'] ?? 0,
      namaKapal: json['nm_kpl'] ?? '',
      namaPelayaran: json['nm_pel'] ?? '',
    );
  }
}

class WilayahModel {
  int idWilayah;
  String wilayah;

  WilayahModel({
    required this.idWilayah,
    required this.wilayah,
  });

  factory WilayahModel.fromJson(Map<String, dynamic> json) {
    return WilayahModel(
      idWilayah: json['id_wilayah'] ?? 0,
      wilayah: json['wilayah'] ?? '',
    );
  }
}

class TypeMotorModel {
  int idType;
  String merk;
  String typeMotor;

  TypeMotorModel({
    required this.idType,
    required this.merk,
    required this.typeMotor,
  });

  factory TypeMotorModel.fromJson(Map<String, dynamic> json) {
    return TypeMotorModel(
      idType: json['id_type'] ?? 0,
      merk: json['merk'] ?? '',
      typeMotor: json['type_motor'] ?? '',
    );
  }
}

class PartMotorModel {
  int idPart;
  String namaPart;

  PartMotorModel({
    required this.idPart,
    required this.namaPart,
  });

  factory PartMotorModel.fromJson(Map<String, dynamic> json) {
    return PartMotorModel(
      idPart: json['id_part'] ?? 0,
      namaPart: json['nm_part'] ?? '',
    );
  }
}
