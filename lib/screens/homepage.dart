import 'package:dooring/utils/constant/storage_util.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final user = storageUtil.getUserDetails();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('username:${user!.username}'),
          Text('password:${user.password}'),
          Text('nama:${user.nama}'),
          Text('tipe:${user.tipe}'),
          Text('app:${user.app}'),
          Text('wilayah:${user.wilayah}'),
          Text('gambar:${user.gambar}'),
          Text('online:${user.online}'),
          Text('idUser:${user.idUser}'),
          Text('lihat:${user.lihat}'),
          Text('print:${user.print}'),
          Text('tambah:${user.tambah}'),
          Text('edit:${user.edit}'),
          Text('hapus:${user.hapus}'),
          Text('menu1:${user.menu1}'),
          Text('menu2:${user.menu2}'),
          Text('menu3:${user.menu3}'),
          Text('menu4:${user.menu4}'),
          Text('menu5:${user.menu5}'),
          Text('menu6:${user.menu6}'),
          Text('menu7:${user.menu7}'),
          Text('menu8:${user.menu8}'),
          Text('menu9:${user.menu9}'),
          Text('menu10:${user.menu10}'),
        ],
      ),
    );
  }
}
