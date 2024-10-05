import 'package:dooring/models/dooring/kapal_model.dart';
import 'package:dooring/utils/popups/dialogs.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/dooring/kapal_controller.dart';
import '../../utils/constant/custom_size.dart';
import '../../utils/loader/circular_loader.dart';
import '../../utils/source/master data/kapal_source.dart';

class MasterKapal extends GetView<KapalController> {
  const MasterKapal({super.key});

  @override
  Widget build(BuildContext context) {
    final pelayaranController = Get.put(PelayaranController());
    late Map<String, double> columnWidths = {
      'No': 50,
      'Nama Pelayaran': 130,
      'Nama Kapal': 130,
      'Edit': 70,
      'Hapus': 70,
    };
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text('Master Kapal',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.kapalModel.isEmpty) {
          return const CustomCircularLoader();
        } else {
          final dataSource = KapalSource(
            onEdited: (KapalModel model) {
              print('ini edit master kapal');
            },
            onDeleted: (KapalModel model) {
              CustomDialogs.deleteDialog(
                  context: context,
                  onConfirm: () => print('ini hapus master kapal'));
            },
            kapalModel: controller.displayedData,
          );
          return Column(
            children: [
              Expanded(
                child: SfDataGrid(
                    source: dataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    verticalScrollController: controller.scrollController,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          width: columnWidths['Nama Kapal']!,
                          columnName: 'Nama Kapal',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Nama Kapal',
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
                      GridColumn(
                          width: columnWidths['Hapus']!,
                          columnName: 'Hapus',
                          label: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.lightBlue.shade100,
                              ),
                              child: Text(
                                'Hapus',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))),
                    ]),
              ),
              if (controller
                  .isLoadingMore.value) // Loader di bawah ketika lazy loading
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          CustomDialogs.defaultDialog(
            context: context,
            contentWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text('Tambah Kapal',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                Expanded(
                  flex: 2,
                  child: Obx(() {
                    return DropdownSearch<PelayaranModel>(
                      items: pelayaranController.filteredPartMotorModel,
                      itemAsString: (PelayaranModel kendaraan) =>
                          kendaraan.namaPel,
                      selectedItem:
                          pelayaranController.selectedWilayah.value.isNotEmpty
                              ? pelayaranController.filteredPartMotorModel
                                  .firstWhere(
                                  (kendaraan) =>
                                      kendaraan.namaPel ==
                                      pelayaranController.selectedWilayah.value,
                                  orElse: () => PelayaranModel(
                                    idPelayaran: 0,
                                    namaPel: '',
                                  ),
                                )
                              : null,
                      dropdownBuilder: (context, PelayaranModel? selectedItem) {
                        return Text(
                          selectedItem != null
                              ? selectedItem.namaPel
                              : 'Nama Pelayaran',
                          style: TextStyle(
                              fontSize: CustomSize.fontSizeSm,
                              color: selectedItem == null
                                  ? Colors.grey
                                  : Colors.black,
                              fontWeight: FontWeight.w600),
                        );
                      },
                      onChanged: (PelayaranModel? kendaraan) {
                        if (kendaraan != null) {
                          pelayaranController.selectedWilayah.value =
                              kendaraan.namaPel;
                          print(
                              'ini nama kapal : ${pelayaranController.selectedWilayah.value}');
                        } else {
                          pelayaranController.resetSelectedKendaraan();
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
                ),
                const SizedBox(height: CustomSize.spaceBtwItems),
                TextFormField(
                  controller: controller.namaKapalController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah Unit harus di isi';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Unit',
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
                        print('nambah data wilayah');
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
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kapal'),
      ),
    );
  }
}
