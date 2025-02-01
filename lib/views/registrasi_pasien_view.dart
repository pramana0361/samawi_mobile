import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simawi_mobile/models/patient_history_model.dart';
import 'package:simawi_mobile/models/patient_model.dart';
import 'package:simawi_mobile/providers/user_provider.dart';
import 'package:simawi_mobile/services/database_service.dart';
import 'package:simawi_mobile/utils/enums.dart';
import 'package:simawi_mobile/utils/functions.dart';

class RegistrasiPasienView extends StatefulWidget {
  const RegistrasiPasienView({super.key});

  @override
  State<RegistrasiPasienView> createState() => _RegistrasiPasienViewState();
}

class _RegistrasiPasienViewState extends State<RegistrasiPasienView> {
  Future<void> managePatientDialog({PatientModel? data}) {
    final patientFormKey = GlobalKey<FormState>();
    TextEditingController dateBirthController = TextEditingController();
    PatientModel patientModel = PatientModel(
        id: 0,
        recordNumber: 0,
        birth: DateTime.now(),
        name: '',
        nik: '',
        phone: '',
        address: '',
        bloodType: BloodType.A,
        weight: 0.0,
        height: 0.0,
        createdAt: 0,
        updatedAt: 0);
    if (data != null) {
      patientModel = data;
    }
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'PATIENT DATA',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            body: FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300.w,
                      child: Form(
                        key: patientFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue:
                                  data == null ? null : patientModel.name,
                              decoration: InputDecoration(
                                labelText: 'Nama',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan nama';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientModel.name = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              controller: dateBirthController,
                              initialValue: data == null
                                  ? null
                                  : milisecondsToDateString(patientModel
                                      .birth.millisecondsSinceEpoch),
                              decoration: InputDecoration(
                                labelText: 'Tgl. Lahir',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan Tgl. Lahir';
                                }
                                return null;
                              },
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (picked != null) {
                                  patientModel.birth = picked;
                                  dateBirthController.text =
                                      milisecondsToDateString(
                                          picked.millisecondsSinceEpoch);
                                }
                              },
                              onSaved: (value) {
                                // if (value != null) {
                                //   patientModel.birth = DateTime.parse(value);
                                // }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue:
                                  data == null ? null : patientModel.nik,
                              decoration: InputDecoration(
                                labelText: 'NIK',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan NIK';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientModel.nik = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue:
                                  data == null ? null : patientModel.phone,
                              decoration: InputDecoration(
                                labelText: 'Telepon',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan No. Telepon';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientModel.phone = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue:
                                  data == null ? null : patientModel.address,
                              decoration: InputDecoration(
                                labelText: 'Alamat',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan alamat';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientModel.address = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            DropdownButtonFormField<BloodType>(
                              value: data == null
                                  ? BloodType.A
                                  : patientModel.bloodType,
                              items:
                                  BloodType.values.map((BloodType bloodType) {
                                return DropdownMenuItem<BloodType>(
                                  value: bloodType,
                                  child: Text(
                                    bloodType.name.toUpperCase(),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              onChanged: data == null ? (value) {} : null,
                              onSaved: (value) {
                                if (value != null) {
                                  patientModel.bloodType = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue: data == null
                                  ? null
                                  : patientModel.weight.toString(),
                              decoration: InputDecoration(
                                labelText: 'Berat',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9.]")),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan berat badan';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  final valParse = double.tryParse(value);
                                  if (valParse != null) {
                                    patientModel.weight = valParse;
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue: data == null
                                  ? null
                                  : patientModel.height.toString(),
                              decoration: InputDecoration(
                                labelText: 'Tinggi',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9.]")),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan tinggi badan';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  final valParse = double.tryParse(value);
                                  if (valParse != null) {
                                    patientModel.height = valParse;
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  if (patientFormKey.currentState!.validate()) {
                                    patientFormKey.currentState!.save();

                                    final timestamp =
                                        DateTime.now().millisecondsSinceEpoch;
                                    patientModel.updatedAt = timestamp;
                                    if (data == null) {
                                      patientModel.recordNumber =
                                          generateRandomInt(5);
                                      patientModel.createdAt = timestamp;
                                      await DatabaseService.putPatient(
                                          patientModel.toMap());
                                    } else {
                                      // TODO: Update pasien
                                    }
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Simpan berhasil'),
                                      ));
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Simpan gagal'),
                                    ));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                fixedSize: Size(150.w, 50.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Text(
                                'Simpan',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ),
                            SizedBox(height: 55.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            title: const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'SIMAWI',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          body: FractionallySizedBox(
            heightFactor: 1.0,
            widthFactor: 1.0,
            child: FutureBuilder(
              future: DatabaseService.getPatientAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final listPatientFromDb = snapshot.data!;
                    List<PatientModel> patientListModel = [];
                    int selectedIndex = -1;
                    for (var element in listPatientFromDb) {
                      patientListModel.add(PatientModel.fromMap(element));
                    }
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await managePatientDialog();
                                      userProvider.setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(70.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Tambah',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                    onPressed: selectedIndex < 0
                                        ? null
                                        : () async {
                                            try {
                                              final patientRecordNumber =
                                                  patientListModel[
                                                          selectedIndex]
                                                      .recordNumber;
                                              DateTime? visitDate;
                                              final DateTime? picked =
                                                  await showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                              );
                                              if (picked != null) {
                                                visitDate = picked;
                                              }

                                              final patientHistoryModel =
                                                  PatientHistoryModel(
                                                id: 0,
                                                recordNumber:
                                                    patientRecordNumber,
                                                dateVisit: visitDate!
                                                    .millisecondsSinceEpoch,
                                                registeredBy:
                                                    userProvider.user.id,
                                                consultationBy: 0,
                                                symptoms: '',
                                                doctorDiagnose: '',
                                                icd10Code: '',
                                                icd10Name: '',
                                                isDone: false,
                                              );
                                              await DatabaseService
                                                  .putPatientHistory(
                                                      patientHistoryModel
                                                          .toMap());
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      'Buat kunjungan berhasil'),
                                                ));
                                              }
                                              userProvider.setState(() {});
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      'Buat kunjungan gagal'),
                                                ));
                                              }
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.green[800],
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(70.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Kunjungan',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                    onPressed: selectedIndex < 0
                                        ? null
                                        : () async {
                                            // TODO : Buka ubah data pasien
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.yellow[800],
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(70.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Ubah',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                    onPressed: selectedIndex < 0
                                        ? null
                                        : () async {
                                            // TODO : Hapus pasien
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(70.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Hapus',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: InteractiveViewer(
                                panAxis: PanAxis.aligned,
                                boundaryMargin:
                                    EdgeInsets.symmetric(vertical: 20.h),
                                constrained: false,
                                scaleEnabled: false,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text('ID'),
                                    ),
                                    DataColumn(
                                      label: Text('No. Record'),
                                    ),
                                    DataColumn(
                                      label: Text('Name'),
                                    ),
                                    DataColumn(
                                      label: Text('Birth'),
                                    ),
                                    DataColumn(
                                      label: Text('NIK'),
                                    ),
                                    DataColumn(
                                      label: Text('Phone'),
                                    ),
                                    DataColumn(
                                      label: Text('Address'),
                                    ),
                                    DataColumn(
                                      label: Text('Blood Type'),
                                    ),
                                    DataColumn(
                                      label: Text('Weight'),
                                    ),
                                    DataColumn(
                                      label: Text('Height'),
                                    ),
                                    DataColumn(
                                      label: Text('Registered'),
                                    ),
                                  ],
                                  rows: List.generate(
                                    patientListModel.length,
                                    (index) => DataRow(
                                      selected:
                                          selectedIndex == index ? true : false,
                                      onLongPress: () {
                                        setState(() {
                                          if (selectedIndex == index) {
                                            selectedIndex = -1;
                                          } else {
                                            selectedIndex = index;
                                          }
                                        });
                                      },
                                      color: WidgetStateProperty.resolveWith<
                                          Color?>(
                                        (states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Colors.teal[200];
                                          }
                                          return null;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Text(
                                            '${patientListModel[index].id}')),
                                        DataCell(Text(
                                            '${patientListModel[index].recordNumber}')),
                                        DataCell(
                                            Text(patientListModel[index].name)),
                                        DataCell(Text(milisecondsToDateString(
                                            patientListModel[index]
                                                .birth
                                                .millisecondsSinceEpoch))),
                                        DataCell(
                                            Text(patientListModel[index].nik)),
                                        DataCell(Text(
                                            patientListModel[index].phone)),
                                        DataCell(Text(
                                            patientListModel[index].address)),
                                        DataCell(Text(patientListModel[index]
                                            .bloodType
                                            .name
                                            .toUpperCase())),
                                        DataCell(Text(
                                            '${patientListModel[index].weight}')),
                                        DataCell(Text(
                                            '${patientListModel[index].height}')),
                                        DataCell(Text(milisecondsToDateString(
                                            patientListModel[index]
                                                .createdAt))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                } else {
                  return SizedBox.square(
                    dimension: 50.sp,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
