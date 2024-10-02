import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MasterPelayaran extends StatelessWidget {
  const MasterPelayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text('Master Pelayaran',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
    );
  }
}
