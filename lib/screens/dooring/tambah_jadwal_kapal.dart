// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../controllers/dooring/jadwal_kapal_controller.dart';
// import '../../helpers/helper_func.dart';
// import '../../models/dooring/jadwal_kapal_model.dart';
// import '../../utils/constant/custom_size.dart';
// import '../../utils/theme/app_colors.dart';

// class TambahJadwalKapal extends StatelessWidget {
//   const TambahJadwalKapal(
//       {super.key, required this.model, required this.controller});

//   final JadwalKapalModel model;
//   final JadwalKapalController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tambah Jadwal Kapal',
//             style: Theme.of(context).textTheme.headlineMedium),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back_ios_new),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(
//             horizontal: CustomSize.md, vertical: CustomSize.sm),
//         children: [
//           const Text('Nama Kapal'),
//           TextFormField(
//             controller: TextEditingController(text: model.namaKapal),
//             readOnly: true,
//             decoration: const InputDecoration(
//                 filled: true, fillColor: AppColors.buttonDisabled),
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('ETD'),
//           TextFormField(
//             controller: TextEditingController(text: model.etd),
//             readOnly: true,
//             decoration: const InputDecoration(
//                 filled: true, fillColor: AppColors.buttonDisabled),
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('ATD'),
//           TextFormField(
//             controller: TextEditingController(text: model.atd),
//             readOnly: true,
//             decoration: const InputDecoration(
//                 filled: true, fillColor: AppColors.buttonDisabled),
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('Wilayah'),
//           TextFormField(
//             controller: TextEditingController(text: model.wilayah),
//             readOnly: true,
//             decoration: const InputDecoration(
//                 filled: true, fillColor: AppColors.buttonDisabled),
//           ),
//           const SizedBox(height: CustomSize.spaceBtwItems),
//           Text(
//             'JUMLAH UNIT & CONTAINER YG BELUM DIBONGKAR',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           const SizedBox(height: CustomSize.spaceBtwItems),
//           const Text('Unit Motor'),
//           TextFormField(
//             controller:
//                 TextEditingController(text: model.unitDooring.toString()),
//             readOnly: true,
//             decoration: const InputDecoration(
//                 filled: true, fillColor: AppColors.buttonDisabled),
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('CT 20"'),
//           TextFormField(
//             controller: TextEditingController(text: model.feet20.toString()),
//             readOnly: true,
//             decoration: const InputDecoration(
//                 filled: true, fillColor: AppColors.buttonDisabled),
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('CT 40"'),
//           TextFormField(
//             controller: TextEditingController(text: model.feet40.toString()),
//             readOnly: true,
//             decoration: const InputDecoration(
//                 filled: true, fillColor: AppColors.buttonDisabled),
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('Tanggal Bongkar'),
//           Obx(
//             () => TextFormField(
//               keyboardType: TextInputType.none,
//               readOnly: true,
//               decoration: InputDecoration(
//                 suffixIcon: IconButton(
//                   onPressed: () {
//                     DateTime? selectedDate =
//                         DateTime.tryParse(controller.tgl.value);
//                     showDatePicker(
//                       context: context,
//                       locale: const Locale("id", "ID"),
//                       initialDate: selectedDate ?? DateTime.now(),
//                       firstDate: DateTime(1850),
//                       lastDate: DateTime(2040),
//                     ).then((newSelectedDate) {
//                       if (newSelectedDate != null) {
//                         controller.tgl.value =
//                             CustomHelperFunctions.getFormattedDateDatabase(
//                                 newSelectedDate);
//                         print(
//                             'Ini tanggal yang dipilih : ${controller.tgl.value}');
//                       }
//                     });
//                   },
//                   icon: const Icon(Icons.calendar_today),
//                 ),
//                 hintText: controller.tgl.value.isNotEmpty
//                     ? DateFormat.yMMMMd('id_ID').format(
//                         DateTime.tryParse('${controller.tgl.value} 00:00:00') ??
//                             DateTime.now(),
//                       )
//                     : 'Tanggal',
//               ),
//             ),
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('Jumlah Unit Bongkar'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Jumlah unit bongkar harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('Jumlah CT 20'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Jumlah CT 20 harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('Jumlah CT 40'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Jumlah CT 40 harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.spaceBtwItems),
//           Center(
//             child: Text(
//               'ALAT - ALAT MOTOR',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ),
//           const SizedBox(height: CustomSize.spaceBtwItems),
//           const Text('Helm'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Helm harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('AC'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'AC harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('KS'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'KS harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('BS'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'BS harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.sm),
//           const Text('TS'),
//           TextFormField(
//             controller: controller.jumlahUnitBongkarController,
//             keyboardType: TextInputType.number,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'TS harus di isi';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: CustomSize.spaceBtwSections),
//           Row(
//             children: [
//               OutlinedButton(
//                   onPressed: () => Get.back(),
//                   style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: CustomSize.lg, vertical: CustomSize.md)),
//                   child: const Text('Close')),
//               const SizedBox(width: CustomSize.defaultSpace),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: CustomSize.lg, vertical: CustomSize.md)),
//                   child: const Text('Tambahkan'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
