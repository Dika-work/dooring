import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/dooring/jadwal_kapal_controller.dart';
import '../../helpers/helper_func.dart';
import '../../models/dooring/jadwal_kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/theme/app_colors.dart';

class TambahDooring extends StatelessWidget {
  const TambahDooring(
      {super.key, required this.controller, required this.model});

  final JadwalKapalController controller;
  final JadwalKapalModel model;

  @override
  Widget build(BuildContext context) {
    final unitMotor = model.totalUnit - model.unitDooring;
    return Scaffold(
        appBar: AppBar(
          title: Text('Tambah Data Dooring',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              controller.jumlahBongkarController.clear();
              controller.ct40Controller.clear();
              controller.ct20Controller.clear();
              controller.helmController.clear();
              controller.accuController.clear();
              controller.spionController.clear();
              controller.buserController.clear();
              controller.toolsetController.clear();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Form(
          key: controller.addDooringKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: CustomSize.md, vertical: CustomSize.sm),
            children: [
              Text('ini jadwal kapal ${model.idJadwal}'),
              const Text('Nama Kapal'),
              TextFormField(
                controller: TextEditingController(text: model.namaKapal),
                readOnly: true,
                decoration: const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.sm),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ETD'),
                        TextFormField(
                          controller: TextEditingController(
                              text: CustomHelperFunctions.getFormattedDate(
                                  DateTime.parse(model.etd))),
                          readOnly: true,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.buttonDisabled),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ATD'),
                        TextFormField(
                          controller: TextEditingController(
                              text: CustomHelperFunctions.getFormattedDate(
                                  DateTime.parse(model.atd))),
                          readOnly: true,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.buttonDisabled),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('Wilayah'),
              TextFormField(
                controller: TextEditingController(text: model.wilayah),
                readOnly: true,
                decoration: const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.sm),
              const Divider(),
              Text(
                'JUMLAH UNIT DAN CONTAINER YG BELUM DI BONGKAR',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('Unit Motor'),
              TextFormField(
                controller: TextEditingController(text: unitMotor.toString()),
                readOnly: true,
                decoration: const InputDecoration(
                    filled: true, fillColor: AppColors.buttonDisabled),
              ),
              const SizedBox(height: CustomSize.sm),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CT 20'),
                        TextFormField(
                          controller: TextEditingController(
                              text: model.feet20.toString()),
                          readOnly: true,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.buttonDisabled),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CT 40'),
                        TextFormField(
                          controller: TextEditingController(
                              text: model.feet40.toString()),
                          readOnly: true,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.buttonDisabled),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('Tgl Bongkar'),
              Obx(
                () => TextFormField(
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        DateTime? selectedDate =
                            DateTime.tryParse(controller.tglBongkar.value);
                        showDatePicker(
                          context: context,
                          locale: const Locale("id", "ID"),
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1850),
                          lastDate: DateTime(2040),
                        ).then((newSelectedDate) {
                          if (newSelectedDate != null) {
                            controller.tglBongkar.value =
                                CustomHelperFunctions.getFormattedDateDatabase(
                                    newSelectedDate);
                            print(
                                'Ini tanggal yang dipilih : ${controller.tglBongkar.value}');
                          }
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                    hintText: controller.tglBongkar.value.isNotEmpty
                        ? DateFormat.yMMMMd('id_ID').format(
                            DateTime.tryParse(
                                    '${controller.tglBongkar.value} 00:00:00') ??
                                DateTime.now(),
                          )
                        : 'Tanggal',
                  ),
                ),
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('Jumlah Unit Bongkar'),
              TextFormField(
                controller: controller.jumlahBongkarController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah unit bongkar harus di isi';
                  }
                  int inputValue = int.tryParse(value) ?? 0;
                  if (inputValue == 0) {
                    return 'Jumlah unit tidak boleh 0';
                  }
                  return null;
                },
                onChanged: (value) {
                  int inputValue = int.tryParse(value) ?? 0;
                  if (inputValue > unitMotor) {
                    controller.jumlahBongkarController.text =
                        unitMotor.toString();
                    controller.jumlahBongkarController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset:
                              controller.jumlahBongkarController.text.length),
                    );
                  }
                },
              ),
              const SizedBox(height: CustomSize.sm),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Jumlah CT 20'),
                        TextFormField(
                          controller: controller.ct20Controller,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah CT 20 harus di isi';
                            }
                            int inputValue = int.tryParse(value) ?? 0;
                            if (inputValue == 0) {
                              return 'Jumlah CT 20 tidak boleh 0';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            int inputValue = int.tryParse(value) ?? 0;
                            if (inputValue > model.feet20) {
                              controller.ct20Controller.text =
                                  model.feet20.toString();
                              controller.ct20Controller.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset:
                                        controller.ct20Controller.text.length),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Jumlah CT 40'),
                        TextFormField(
                          controller: controller.ct40Controller,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah CT 20 harus di isi';
                            }
                            int inputValue = int.tryParse(value) ?? 0;
                            if (inputValue == 0) {
                              return 'Jumlah CT 20 tidak boleh 0';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            int inputValue = int.tryParse(value) ?? 0;
                            if (inputValue > model.feet40) {
                              controller.ct40Controller.text =
                                  model.feet40.toString();
                              controller.ct40Controller.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset:
                                        controller.ct40Controller.text.length),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.sm),
              const Divider(),
              Center(
                child: Text(
                  'ALAT - ALAT MOTOR',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: CustomSize.sm),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('HLM'),
                        TextFormField(
                          controller: controller.helmController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Helm harus di isi';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AC'),
                        TextFormField(
                          controller: controller.accuController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Accu harus di isi';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.sm),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('KS'),
                        TextFormField(
                          controller: controller.spionController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Spion harus di isi';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: CustomSize.md),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BS'),
                        TextFormField(
                          controller: controller.buserController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Buser harus di isi';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: CustomSize.sm),
              const Text('TS'),
              TextFormField(
                controller: controller.toolsetController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Toolset harus di isi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: CustomSize.spaceBtwSections),
              SizedBox(
                width: CustomHelperFunctions.screenWidth(),
                child: ElevatedButton(
                    onPressed: () => controller.addDataDooring(model.idJadwal,
                        model.namaKapal, model.wilayah, model.etd, model.atd),
                    // onPressed: () {
                    //   controller.addDataDooring(model.idJadwal, model.namaKapal,
                    //       model.wilayah, model.etd, model.atd);
                    //   print('ini id jadwal nya: ${model.idJadwal}');
                    //   print('ini nama kapal nya: ${model.namaKapal}');
                    //   print(
                    //       'ini jam yg di input : ${CustomHelperFunctions.formattedTime}');
                    //   print(
                    //       'ini tanggal inputnya : ${controller.tglInput.value}');
                    //   print('ini nama user yg input: ${controller.nameUser}');
                    //   print('ini wilayah nya : ${model.wilayah}');
                    //   print('ini tgl etd : ${model.etd}');
                    //   print('ini tgl atd : ${model.atd}');
                    //   print('ini tgl bongkar: ${controller.tglBongkar.value}');
                    //   print(
                    //       'ini jumlah unit bongkarnya : ${controller.jumlahBongkarController.text}');
                    //   print('ini ct 40: ${controller.ct40Controller.text}');
                    //   print('ini ct 20: ${controller.ct20Controller.text}');
                    //   print('ini helm: ${controller.helmController.text}');
                    //   print('ini accu: ${controller.accuController.text}');
                    //   print('ini spion: ${controller.spionController.text}');
                    //   print('ini buser: ${controller.buserController.text}');
                    //   print(
                    //       'ini toolset: ${controller.toolsetController.text}');
                    // },
                    child: const Text(
                      'Tambah',
                    )),
              )
            ],
          ),
        ));
  }
}
