import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dooring/utils/popups/dialogs.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/jadwal_kapal_controller.dart';
import '../../controllers/dooring/kapal_controller.dart';
import '../../helpers/connectivity.dart';
import '../../helpers/helper_func.dart';
import '../../models/dooring/jadwal_kapal_model.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/seluruh data/jadwal_kapal_source.dart';
import '../../utils/theme/app_colors.dart';
import '../dooring/lihat_jadwal_kapal.dart';
import '../dooring/tambah_dooring.dart';

class JadwalSemuaKapal extends GetView<JadwalKapalController> {
  const JadwalSemuaKapal({super.key});

  @override
  Widget build(BuildContext context) {
    final kapalController = Get.put(KapalController());
    final wilayahController = Get.put(WilayahController());
    final networkConn = Get.find<NetworkManager>();

    final RxBool hasFetchedData = false.obs;

    // Cek koneksi internet saat pertama kali layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await networkConn.isConnected()) {
        SnackbarLoader.errorSnackBar(
          title: 'Tidak ada internet',
          message: 'Silahkan coba lagi setelah koneksi tersedia',
        );
        return;
      }

      if (!hasFetchedData.value) {
        await controller.fetchJadwalKapal();
        hasFetchedData.value = true;
      }
    });

    late Map<String, double> columnWidths = {
      'No': 50,
      'Nama Pelayaran': 100,
      'Tgl Input': 100,
      if (controller.isAdmin) 'Wilayah': 70,
      'ETD': 100,
      'ATD': 100,
      'Total Unit': 80,
      'Total 20': 80,
      'Total 40': 80,
      'Total Bongkar': 100,
      'Bongkar 20': 100,
      'Bongkar 40': 100,
      'Unit Dooring': 100,
      'Lihat': 80,
      'Add Dooring': double.nan,
      'Edit': 80,
    };

    Widget buildDateField({
      required BuildContext context,
      required String label,
      required String value,
      required Function(String) onDateSelected,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  DateTime? selectedDate = DateTime.tryParse(value);
                  showDatePicker(
                    context: context,
                    locale: const Locale("id", "ID"),
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1850),
                    lastDate: DateTime(2040),
                  ).then((newDate) {
                    if (newDate != null) {
                      onDateSelected(
                          CustomHelperFunctions.getFormattedDateDatabase(
                              newDate));
                    }
                  });
                },
                icon: const Icon(Icons.calendar_today),
              ),
              hintText: value.isNotEmpty
                  ? DateFormat.yMMMMd('id_ID').format(
                      DateTime.tryParse('$value 00:00:00') ?? DateTime.now(),
                    )
                  : 'Tanggal',
            ),
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text('Seluruh Jadwal Kapal',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value &&
              controller.jadwalKapalModel.isEmpty) {
            return const CustomCircularLoader();
          } else if (controller.jadwalKapalModel.isEmpty) {
            return CustomAnimationLoaderWidget(
              text: 'Tidak ada data saat ini',
              animation: 'assets/animations/404.json',
              height: CustomHelperFunctions.screenHeight() * 0.4,
              width: CustomHelperFunctions.screenHeight(),
            );
          }
          if (networkConn.connectionStatus == ConnectivityResult.none) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomAnimationLoaderWidget(
                  text:
                      'Koneksi internet terputus\nsilakan tekan tombol refresh untuk mencoba kembali.',
                  animation: 'assets/animations/404.json',
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () async {
                    if (await networkConn.isConnected()) {
                      await controller.fetchJadwalKapal();
                    } else {
                      SnackbarLoader.errorSnackBar(
                        title: 'Tidak ada internet',
                        message: 'Silahkan coba lagi setelah koneksi tersedia',
                      );
                    }
                  },
                  child: const Text('Refresh'),
                ),
              ],
            );
          }

          final dataSource = JadwalKapalSource(
            isAdmin: controller.isAdmin,
            onLihat: (int id) {
              Get.to(() => LihatJadwalKapal(
                    idJadwal: id,
                    controller: controller,
                  ));
            },
            addDooring: (JadwalKapalModel model, String action) async {
              if (action == 'add') {
                await Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TambahDooring(
                    controller: controller,
                    model: model,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = 0.0;
                    const end = 1.0;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    return FadeTransition(
                      opacity: animation.drive(tween),
                      child: child,
                    );
                  },
                ));
              } else if (action == 'check') {
                print('ini btn checllist');
              }
            },
            onEdited: (JadwalKapalModel model, String action) {
              if (action == 'edit') {
                CustomDialogs.defaultDialog(
                  context: context,
                  margin: const EdgeInsets.only(
                      top: CustomSize.defaultSpace,
                      bottom: CustomSize.defaultSpace),
                  contentWidget: Form(
                    key: controller.jadwalKapalKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Edit Data Dooring',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: CustomSize.sm),
                          Text('Nama Kapal',
                              style: Theme.of(context).textTheme.labelMedium),
                          Obx(() {
                            return DropdownSearch<KapalModel>(
                              items: kapalController.filteredKapalModel,
                              itemAsString: (KapalModel kapal) =>
                                  kapal.namaKapal,
                              selectedItem:
                                  kapalController.filteredKapalModel.firstWhere(
                                (kapal) => kapal.namaKapal == model.namaKapal,
                                orElse: () => KapalModel(
                                    idPelayaran: 0,
                                    namaKapal: '',
                                    namaPelayaran: ''),
                              ),
                              onChanged: (KapalModel? kapal) {
                                if (kapal != null) {
                                  model.namaKapal = kapal.namaKapal;
                                }
                              },
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: 'Cari nama kapal...',
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: CustomSize.sm),
                          buildDateField(
                            context: context,
                            label: 'ETD',
                            value: model.etd,
                            onDateSelected: (date) => model.etd = date,
                          ),
                          const SizedBox(height: CustomSize.sm),
                          buildDateField(
                            context: context,
                            label: 'ATD',
                            value: model.atd,
                            onDateSelected: (date) => model.atd = date,
                          ),
                          const SizedBox(height: CustomSize.sm),
                          Text('Total Motor',
                              style: Theme.of(context).textTheme.labelMedium),
                          TextFormField(
                            initialValue: model.totalUnit.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                model.totalUnit = int.tryParse(value) ?? 0,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Total Motor harus diisi';
                              }
                              model.totalUnit = int.tryParse(value) ?? 0;
                              if (model.totalUnit < model.unitDooring) {
                                return 'Total motor tidak boleh kurang dari unit yang telah di bongkar, unit yang telah di bongkar sebanyak ${model.unitDooring} unit';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: CustomSize.sm),
                          Text('Total CT 20"',
                              style: Theme.of(context).textTheme.labelMedium),
                          TextFormField(
                            initialValue: model.feet20.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                model.feet20 = int.tryParse(value) ?? 0,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Total CT 20" harus diisi';
                              }
                              model.feet20 = int.tryParse(value) ?? 0;
                              if (model.feet20 < model.unitDooring) {
                                return 'Total CT 20" tidak boleh kurang dari CT 20 yang telah di bongkar, CT 20 yang telah di bongkar sebanyak ${model.ct20Dooring}';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: CustomSize.sm),
                          Text('Total CT 40"',
                              style: Theme.of(context).textTheme.labelMedium),
                          TextFormField(
                            initialValue: model.feet40.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                model.feet40 = int.tryParse(value) ?? 0,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Total CT 40" harus diisi';
                              }
                              model.feet40 = int.tryParse(value) ?? 0;
                              if (model.feet40 < model.unitDooring) {
                                return 'Total CT 40" tidak boleh kurang dari CT 40 yang telah di bongkar, CT 40 yang telah di bongkar sebanyak ${model.ct40Dooring}';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: CustomSize.sm),
                          Text('Wilayah',
                              style: Theme.of(context).textTheme.labelMedium),
                          Obx(() {
                            return DropdownSearch<WilayahModel>(
                              items: wilayahController.filteredWilayahModel,
                              itemAsString: (WilayahModel wilayah) =>
                                  wilayah.wilayah,
                              selectedItem: wilayahController
                                  .filteredWilayahModel
                                  .firstWhere(
                                (wilayah) => wilayah.wilayah == model.wilayah,
                                orElse: () =>
                                    WilayahModel(idWilayah: 0, wilayah: ''),
                              ),
                              onChanged: (WilayahModel? wilayah) {
                                if (wilayah != null) {
                                  model.wilayah = wilayah.wilayah;
                                }
                              },
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: 'Search Wilayah...',
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: CustomSize.spaceBtwSections),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () => Get.back(),
                                child: const Text('Close'),
                              ),
                              const SizedBox(width: CustomSize.sm),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    print('Nama Kapal: ${model.namaKapal}');
                                    print('ETD: ${model.etd}');
                                    print('ATD: ${model.atd}');
                                    print('Total Unit: ${model.totalUnit}');
                                    print('Total CT 20": ${model.feet20}');
                                    print('Total CT 40": ${model.feet40}');
                                    print('Wilayah: ${model.wilayah}');
                                    controller.editKapalContent(
                                        model.idJadwal,
                                        model.namaKapal,
                                        model.wilayah,
                                        model.etd,
                                        model.atd,
                                        model.totalUnit,
                                        model.feet20,
                                        model.feet40);
                                  },
                                  child: const Text('Update'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (action == 'cross') {
                print('ini membatalkan jadwal kapal');
              }
            },
            jadwalKapalModel: controller.jadwalKapalModel,
          );

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchJadwalKapal();
            },
            child: SfDataGrid(
                source: dataSource,
                frozenColumnsCount: 2,
                columnWidthMode: ColumnWidthMode.auto,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                columns: [
                  GridColumn(
                      width: columnWidths['No']!,
                      columnName: 'No',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'No',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Nama Pelayaran']!,
                      columnName: 'Nama Pelayaran',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Nama Pelayaran',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Tgl Input']!,
                      columnName: 'Tgl Input',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Tgl Input',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  if (controller.isAdmin)
                    GridColumn(
                        width: columnWidths['Wilayah']!,
                        columnName: 'Wilayah',
                        label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.lightBlue.shade100,
                            ),
                            child: Text(
                              'Wilayah',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ))),
                  GridColumn(
                      width: columnWidths['ETD']!,
                      columnName: 'ETD',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'ETD',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['ATD']!,
                      columnName: 'ATD',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'ATD',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Total Unit']!,
                      columnName: 'Total Unit',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Total Unit',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Total 20']!,
                      columnName: 'Total 20',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Total 20',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Total 40']!,
                      columnName: 'Total 40',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Total 40',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Total Bongkar']!,
                      columnName: 'Total Bongkar',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Total Bongkar',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Bongkar 20']!,
                      columnName: 'Bongkar 20',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Bongkar 20',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Bongkar 40']!,
                      columnName: 'Bongkar 40',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Bongkar 40',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Unit Dooring']!,
                      columnName: 'Unit Dooring',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Unit Dooring',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Lihat']!,
                      columnName: 'Lihat',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Lihat',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Add Dooring']!,
                      columnName: 'Add Dooring',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Add Dooring',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                      width: columnWidths['Edit']!,
                      columnName: 'Edit',
                      label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.lightBlue.shade100,
                          ),
                          child: Text(
                            'Edit',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ))),
                ]),
          );
        }),
        floatingActionButton: Obx(() {
          return networkConn.connectionStatus != ConnectivityResult.none
              ? FloatingActionButton.extended(
                  onPressed: () {
                    CustomDialogs.defaultDialog(
                        context: context,
                        contentWidget: Form(
                          key: controller.jadwalKapalKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text('Tambah Jadwal Kapal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ),
                              const Divider(),
                              const SizedBox(height: CustomSize.sm),
                              Text('Nama Kapal',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Obx(() {
                                return DropdownSearch<KapalModel>(
                                  items: kapalController.filteredKapalModel,
                                  itemAsString: (KapalModel kendaraan) =>
                                      kendaraan.namaKapal,
                                  selectedItem: kapalController
                                          .selectedKapal.value.isNotEmpty
                                      ? kapalController.filteredKapalModel
                                          .firstWhere(
                                          (kendaraan) =>
                                              kendaraan.namaKapal ==
                                              kapalController
                                                  .selectedKapal.value,
                                          orElse: () => KapalModel(
                                            idPelayaran: 0,
                                            namaKapal: '',
                                            namaPelayaran: '',
                                          ),
                                        )
                                      : null,
                                  dropdownBuilder:
                                      (context, KapalModel? selectedItem) {
                                    return Text(
                                      selectedItem != null
                                          ? selectedItem.namaKapal
                                          : 'Pilih nama kapal',
                                      style: TextStyle(
                                          fontSize: CustomSize.fontSizeSm,
                                          color: selectedItem == null
                                              ? Colors.grey
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                    );
                                  },
                                  onChanged: (KapalModel? kendaraan) {
                                    if (kendaraan != null) {
                                      kapalController.selectedKapal.value =
                                          kendaraan.namaKapal;
                                      print(
                                          'ini nama kapal : ${kapalController.selectedKapal.value}');
                                    } else {
                                      kapalController.resetSelectedKendaraan();
                                    }
                                  },
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Cari nama kapal...',
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: CustomSize.sm),
                              Text('ETD',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Obx(
                                () => TextFormField(
                                  keyboardType: TextInputType.none,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        DateTime? selectedDate =
                                            DateTime.tryParse(controller
                                                .etdAddJadwalKapal.value);
                                        showDatePicker(
                                          context: context,
                                          locale: const Locale("id", "ID"),
                                          initialDate:
                                              selectedDate ?? DateTime.now(),
                                          firstDate: DateTime(1850),
                                          lastDate: DateTime(2040),
                                        ).then((newSelectedDate) {
                                          if (newSelectedDate != null) {
                                            controller.etdAddJadwalKapal.value =
                                                CustomHelperFunctions
                                                    .getFormattedDateDatabase(
                                                        newSelectedDate);
                                            print(
                                                'Ini tanggal yang dipilih : ${controller.etdAddJadwalKapal.value}');
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.calendar_today),
                                    ),
                                    hintText: controller
                                            .etdAddJadwalKapal.value.isNotEmpty
                                        ? DateFormat.yMMMMd('id_ID').format(
                                            DateTime.tryParse(
                                                    '${controller.etdAddJadwalKapal.value} 00:00:00') ??
                                                DateTime.now(),
                                          )
                                        : 'Tanggal',
                                  ),
                                ),
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Text('ATD',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Obx(
                                () => TextFormField(
                                  keyboardType: TextInputType.none,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        DateTime? selectedDate =
                                            DateTime.tryParse(controller
                                                .atdAddJadwalKapal.value);
                                        showDatePicker(
                                          context: context,
                                          locale: const Locale("id", "ID"),
                                          initialDate:
                                              selectedDate ?? DateTime.now(),
                                          firstDate: DateTime(1850),
                                          lastDate: DateTime(2040),
                                        ).then((newSelectedDate) {
                                          if (newSelectedDate != null) {
                                            controller.atdAddJadwalKapal.value =
                                                CustomHelperFunctions
                                                    .getFormattedDateDatabase(
                                                        newSelectedDate);
                                            print(
                                                'Ini tanggal yang dipilih : ${controller.atdAddJadwalKapal.value}');
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.calendar_today),
                                    ),
                                    hintText: controller
                                            .atdAddJadwalKapal.value.isNotEmpty
                                        ? DateFormat.yMMMMd('id_ID').format(
                                            DateTime.tryParse(
                                                    '${controller.atdAddJadwalKapal.value} 00:00:00') ??
                                                DateTime.now(),
                                          )
                                        : 'Tanggal',
                                  ),
                                ),
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Text('Total Motor',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller: controller.totalUnitAddJadwalKapal,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Total motor harus di isi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Text('Total CT 20"',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller: controller.feed20AddJadwalKapal,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Total CT 20" harus di isi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Text('Total CT 40"',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller: controller.feed40AddJadwalKapal,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Total CT 40" harus di isi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Text('Wilayah',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Obx(() {
                                return DropdownSearch<WilayahModel>(
                                  items: wilayahController.filteredWilayahModel,
                                  itemAsString: (WilayahModel kendaraan) =>
                                      kendaraan.wilayah,
                                  selectedItem: wilayahController
                                          .selectedWilayah.value.isNotEmpty
                                      ? wilayahController.filteredWilayahModel
                                          .firstWhere(
                                          (kendaraan) =>
                                              kendaraan.wilayah ==
                                              wilayahController
                                                  .selectedWilayah.value,
                                          orElse: () => WilayahModel(
                                            idWilayah: 0,
                                            wilayah: '',
                                          ),
                                        )
                                      : null,
                                  dropdownBuilder:
                                      (context, WilayahModel? selectedItem) {
                                    return Text(
                                      selectedItem != null
                                          ? selectedItem.wilayah
                                          : 'Wilayah',
                                      style: TextStyle(
                                          fontSize: CustomSize.fontSizeSm,
                                          color: selectedItem == null
                                              ? Colors.grey
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                    );
                                  },
                                  onChanged: (WilayahModel? kendaraan) {
                                    if (kendaraan != null) {
                                      wilayahController.selectedWilayah.value =
                                          kendaraan.wilayah;
                                      print(
                                          'ini nama kapal : ${wilayahController.selectedWilayah.value}');
                                    } else {
                                      wilayahController
                                          .resetSelectedKendaraan();
                                    }
                                  },
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Search Kendaraan...',
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(
                                  height: CustomSize.spaceBtwSections),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                      onPressed: () => Get.back(),
                                      style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: CustomSize.lg,
                                              vertical: CustomSize.md)),
                                      child: const Text('Close')),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.addJadwalKapal();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: CustomSize.lg,
                                            vertical: CustomSize.md)),
                                    child: const Text('Tambahkan'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
                  },
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                  label: Text('Add Data',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.apply(color: AppColors.white)))
              : const SizedBox.shrink();
        }));
  }
}
