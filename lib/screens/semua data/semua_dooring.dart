import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/dooring_controller.dart';
import '../../controllers/dooring/kapal_controller.dart';
import '../../helpers/connectivity.dart';
import '../../helpers/helper_func.dart';
import '../../models/dooring/dooring_model.dart';
import '../../models/dooring/kapal_model.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/animation_loader.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/popups/dialogs.dart';
import '../../utils/popups/snackbar.dart';
import '../../utils/source/seluruh data/semua_dooring_source.dart';
import '../../widgets/dropdown.dart';
import 'lihat_semua_dooring.dart';
import 'tambah_semua_dooring.dart';

class SemuaDooring extends GetView<DooringController> {
  const SemuaDooring({super.key});

  @override
  Widget build(BuildContext context) {
    final typeMotorController = Get.put(TypeMotorController());
    final kapalController = Get.put(KapalController());
    final networkConn = Get.find<NetworkManager>();

    final RxBool isConnected = true.obs;
    final RxBool hasFetchedData = false.obs;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!await networkConn.isConnected()) {
          isConnected.value = false;
          SnackbarLoader.errorSnackBar(
            title: 'Tidak ada internet',
            message: 'Silahkan coba lagi setelah koneksi tersedia',
          );
          return;
        }
        isConnected.value = true;
        if (!hasFetchedData.value) {
          await controller.fetchAllDooringData();
        }
      },
    );

    late Map<String, double> columnWidths = {
      'No': 50,
      if (controller.isAdmin) 'Wilayah': 70,
      'Tgl Input': 100,
      'Nama Pelayaran': 150,
      'ETD': 100,
      'Tgl Bongkar': 100,
      'Unit Bongkar': 100,
      if (controller.lihatRole != 0) 'Lihat': 80,
      if (controller.tambahRole != 0) 'Defect': 80,
      if (controller.editRole != 0) 'Edit': 80,
    };
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text('Semua Data Dooring',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allDooringModel.isEmpty) {
          return const CustomCircularLoader();
        } else if (controller.originalAllDooringModel.isEmpty) {
          return CustomAnimationLoaderWidget(
            text: 'Tidak ada data saat ini',
            animation: 'assets/animations/404.json',
            height: CustomHelperFunctions.screenHeight() * 0.4,
            width: CustomHelperFunctions.screenHeight(),
          );
        } else {
          final dataSource = SemuaDooringSource(
            isAdmin: controller.isAdmin,
            onLihat: (AllDooringModel model) {
              Get.to(() => LihatSemuaDooring(model: model));
            },
            onDefect: (AllDooringModel model) async {
              if (model.statusDefect == 0) {
                CustomDialogs.defaultDialog(
                  contentWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('Konfirmasi Defect Motor',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      const Divider(),
                      const SizedBox(height: CustomSize.sm),
                      Text('Nama Kapal',
                          style: Theme.of(context).textTheme.labelMedium),
                      TextFormField(
                        controller:
                            TextEditingController(text: model.namaKapal),
                        readOnly: true,
                      ),
                      const SizedBox(height: CustomSize.sm),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tanggal Bongkar',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller: TextEditingController(
                                    text: model.tglBongkar),
                                readOnly: true,
                              ),
                            ],
                          )),
                          const SizedBox(width: CustomSize.sm),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ETD',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller:
                                    TextEditingController(text: model.etd),
                                readOnly: true,
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: CustomSize.sm),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jumlah Unit',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller: TextEditingController(
                                    text: model.unit.toString()),
                                readOnly: true,
                              ),
                            ],
                          )),
                          const SizedBox(width: CustomSize.sm),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Wilayah',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              TextFormField(
                                controller:
                                    TextEditingController(text: model.wilayah),
                                readOnly: true,
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: CustomSize.sm),
                      Text('Status Defect',
                          style: Theme.of(context).textTheme.labelMedium),
                      Obx(
                        () => DropDownWidget(
                          value: controller.statusDefect.value,
                          items: controller.listStatusDefect.keys.toList(),
                          onChanged: (String? value) {
                            controller.statusDefect.value = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: CustomSize.spaceBtwSections),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              controller.changeStatusDefect(
                                  model.idDooring, controller.getStatusDefect);
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
                  context: context,
                );
              } else if (model.statusDefect == 1) {
                await Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TambahAllDefect(
                    model: model,
                    controller: typeMotorController,
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
              }
            },
            onEdited: (AllDooringModel model) {
              CustomDialogs.defaultDialog(
                  context: context,
                  margin: const EdgeInsets.symmetric(vertical: CustomSize.xl),
                  contentWidget: EditAllDooring(
                    model: model,
                    controller: controller,
                  ));
            },
            dooringModel: controller.allDooringModel,
          );

          return StreamBuilder<ConnectivityResult>(
            stream: networkConn.connectionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final connectionStatus = snapshot.data;

                if (connectionStatus == ConnectivityResult.none) {
                  isConnected.value = false;
                } else {
                  isConnected.value = true;
                  print(('koneksi tersambung'));
                  if (!hasFetchedData.value) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      controller.fetchDooringData();
                      hasFetchedData.value = true; // Set flag true
                    });
                  }
                }
              }
              return isConnected.value
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              CustomSize.sm, CustomSize.sm, CustomSize.sm, 0),
                          child: Obx(() {
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
                                          kapalController.selectedKapal.value,
                                      orElse: () => KapalModel(
                                        idPelayaran: 0,
                                        namaKapal: '',
                                        namaPelayaran: '',
                                      ),
                                    )
                                  : null,
                              dropdownBuilder:
                                  (context, KapalModel? selectedItem) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedItem != null
                                          ? selectedItem.namaKapal
                                          : 'Cari berdasarkan nama kapal',
                                      style: TextStyle(
                                        fontSize: CustomSize.fontSizeSm,
                                        color: selectedItem == null
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    kapalController
                                            .selectedKapal.value.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Iconsax.trash,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              kapalController
                                                  .selectedKapal.value = '';
                                              controller
                                                  .filterAllJadwalKapalByNamaKapal(
                                                      '');
                                            },
                                          )
                                        : const Center(
                                            child: Icon(Icons.search)),
                                  ],
                                );
                              },
                              onChanged: (KapalModel? kendaraan) {
                                if (kendaraan != null) {
                                  kapalController.selectedKapal.value =
                                      kendaraan.namaKapal;
                                  // Panggil fungsi filter ketika kapal dipilih
                                  controller.filterAllJadwalKapalByNamaKapal(
                                      kendaraan.namaKapal);
                                } else {
                                  kapalController.resetSelectedKendaraan();
                                  // Jika tidak ada kapal yang dipilih, tampilkan semua data
                                  controller
                                      .filterAllJadwalKapalByNamaKapal('');
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
                        ),
                        const SizedBox(height: CustomSize.gridViewSpacing),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await controller.fetchAllDooringData();
                            },
                            child: SfDataGrid(
                                source: dataSource,
                                frozenColumnsCount: 2,
                                columnWidthMode: ColumnWidthMode.auto,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                columns: [
                                  GridColumn(
                                      width: columnWidths['No']!,
                                      columnName: 'No',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'No',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  if (controller.isAdmin)
                                    GridColumn(
                                        width: columnWidths['Wilayah']!,
                                        columnName: 'Wilayah',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Wilayah',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                  GridColumn(
                                      width: columnWidths['Tgl Input']!,
                                      columnName: 'Tgl Input',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'Tgl Input',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidths['Nama Pelayaran']!,
                                      columnName: 'Nama Pelayaran',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'Nama Pelayaran',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidths['ETD']!,
                                      columnName: 'ETD',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'ETD',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidths['Tgl Bongkar']!,
                                      columnName: 'Tgl Bongkar',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'Tgl Bongkar',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      width: columnWidths['Unit Bongkar']!,
                                      columnName: 'Unit Bongkar',
                                      label: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          child: Text(
                                            'Unit Bongkar',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ))),
                                  if (controller.lihatRole != 0)
                                    GridColumn(
                                        width: columnWidths['Lihat']!,
                                        columnName: 'Lihat',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Lihat',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                  if (controller.tambahRole != 0)
                                    GridColumn(
                                        width: columnWidths['Defect']!,
                                        columnName: 'Defect',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Defect',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                  if (controller.editRole != 0)
                                    GridColumn(
                                        width: columnWidths['Edit']!,
                                        columnName: 'Edit',
                                        label: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: Colors.lightBlue.shade100,
                                            ),
                                            child: Text(
                                              'Edit',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))),
                                ]),
                          ),
                        ),
                      ],
                    )
                  : Column(
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
                            // Coba refresh dan cek koneksi kembali
                            if (await networkConn.isConnected()) {
                              await controller.fetchDooringData();
                            } else {
                              SnackbarLoader.errorSnackBar(
                                title: 'Tidak ada internet',
                                message:
                                    'Silahkan coba lagi setelah koneksi tersedia',
                              );
                            }
                          },
                          child: const Text('Refresh'),
                        ),
                      ],
                    );
            },
          );
        }
      }),
    );
  }
}
