class UserModel {
  String username;
  String password;
  String nama;
  String tipe;
  String app;
  String wilayah;
  String gambar;
  int online;
  int idUser;
  int lihat;
  int print;
  int tambah;
  int edit;
  int hapus;
  int menu1;
  int menu2;
  int menu3;
  int menu4;
  int menu5;
  int menu6;
  int menu7;
  int menu8;
  int menu9;
  int menu10;

  UserModel({
    required this.username,
    required this.password,
    required this.nama,
    required this.tipe,
    required this.app,
    required this.lihat,
    required this.print,
    required this.tambah,
    required this.edit,
    required this.hapus,
    required this.wilayah,
    required this.menu1,
    required this.menu2,
    required this.menu3,
    required this.menu4,
    required this.menu5,
    required this.menu6,
    required this.menu7,
    required this.menu8,
    required this.menu9,
    required this.menu10,
    required this.gambar,
    required this.online,
    required this.idUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      nama: json['nama'] ?? '',
      tipe: json['tipe'] ?? '',
      app: json['app'] ?? '',
      wilayah: json['wilayah'] ?? '',
      gambar: json['gambar'] ?? '',
      lihat: json['lihat'] ?? 0,
      print: json['print'] ?? 0,
      tambah: json['tambah'] ?? 0,
      edit: json['edit'] ?? 0,
      hapus: json['hapus'] ?? 0,
      menu1: json['menu1'] ?? 0,
      menu2: json['menu2'] ?? 0,
      menu3: json['menu3'] ?? 0,
      menu4: json['menu4'] ?? 0,
      menu5: json['menu5'] ?? 0,
      menu6: json['menu6'] ?? 0,
      menu7: json['menu7'] ?? 0,
      menu8: json['menu8'] ?? 0,
      menu9: json['menu9'] ?? 0,
      menu10: json['menu10'] ?? 0,
      online: json['online'] ?? 0,
      idUser: json['online'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'nama': nama,
      'tipe': tipe,
      'app': app,
      'lihat': lihat,
      'print': print,
      'tambah': tambah,
      'edit': edit,
      'hapus': hapus,
      'wilayah': wilayah,
      'menu1': menu1,
      'menu2': menu2,
      'menu3': menu3,
      'menu4': menu4,
      'menu5': menu5,
      'menu6': menu6,
      'menu7': menu7,
      'menu8': menu8,
      'menu9': menu9,
      'menu10': menu10,
      'gambar': gambar,
      'online': online,
    };
  }
}
