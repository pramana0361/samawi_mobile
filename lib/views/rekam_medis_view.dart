import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simawi_mobile/models/patient_history_model.dart';
import 'package:simawi_mobile/models/patient_model.dart';
import 'package:simawi_mobile/providers/patient_provider.dart';
import 'package:simawi_mobile/providers/user_provider.dart';
import 'package:simawi_mobile/services/database_service.dart';
import 'package:simawi_mobile/utils/functions.dart';

class RekamMedisView extends StatefulWidget {
  const RekamMedisView({super.key});

  @override
  State<RekamMedisView> createState() => _RekamMedisViewState();
}

class _RekamMedisViewState extends State<RekamMedisView> {
  Future<void> emrDialog({required PatientHistoryModel data}) {
    final emrFormKey = GlobalKey<FormState>();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    PatientHistoryModel patientHistoryModel = data;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'EMR',
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
                        key: emrFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue: patientHistoryModel.symptoms,
                              decoration: InputDecoration(
                                labelText: 'Symptoms',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              minLines: 3,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan symptoms';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientHistoryModel.symptoms = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue: patientHistoryModel.doctorDiagnose,
                              decoration: InputDecoration(
                                labelText: 'Diagnose',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              minLines: 3,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan diagnosa';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientHistoryModel.doctorDiagnose = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue: patientHistoryModel.icd10Code,
                              decoration: InputDecoration(
                                labelText: 'ICD 10 Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan ICD 10 Code';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientHistoryModel.icd10Code = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              initialValue: patientHistoryModel.icd10Name,
                              decoration: InputDecoration(
                                labelText: 'ICD 10 Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan ICD 10 Name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  patientHistoryModel.icd10Name = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  if (emrFormKey.currentState!.validate()) {
                                    emrFormKey.currentState!.save();
                                    patientHistoryModel.consultationBy =
                                        userProvider.user.id;
                                    patientHistoryModel.isDone = true;
                                    await DatabaseService.updatePatientHistory(
                                        patientHistoryModel.toMap());
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Simpan berhasil'),
                                      ));
                                    }
                                  }
                                } catch (e) {
                                  patientHistoryModel.consultationBy = 0;
                                  patientHistoryModel.isDone = false;
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

  Future<void> modalBottomPatientHistoryList() async {
    return await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Selector<PatientProvider, List<PatientHistoryModel>>(
          selector: (ctx, provider) => provider.patientHistoryList,
          builder: (context, patientHistoryList, child) {
            return Container(
              padding: EdgeInsets.only(top: 10.h),
              height: 0.6.sh,
              width: 1.0.sw,
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(
                      label: Text('ID'),
                    ),
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(
                      label: Text('ICD 10 Code'),
                    ),
                  ],
                  rows: List.generate(
                    patientHistoryList.length,
                    (index) => DataRow(
                      color: WidgetStateProperty.resolveWith<Color?>(
                        (states) {
                          if (patientHistoryList[index].isDone) {
                            return Colors.teal[200];
                          } else {
                            return Colors.yellow[200];
                          }
                        },
                      ),
                      cells: [
                        DataCell(
                          Text('${patientHistoryList[index].id}'),
                          onTap: () {
                            Navigator.pop(context);
                            emrDialog(data: patientHistoryList[index]);
                          },
                        ),
                        DataCell(
                          Text(milisecondsToDateString(
                              patientHistoryList[index].dateVisit)),
                          onTap: () {
                            Navigator.pop(context);
                            emrDialog(data: patientHistoryList[index]);
                          },
                        ),
                        DataCell(
                          Text(patientHistoryList[index].icd10Code.isEmpty
                              ? '-'
                              : patientHistoryList[index].icd10Code),
                          onTap: () {
                            Navigator.pop(context);
                            emrDialog(data: patientHistoryList[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, PatientProvider>(
      builder: (context, userProvider, patientProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            title: const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'SAMAWI',
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
                                    onPressed: selectedIndex < 0
                                        ? null
                                        : () async {
                                            try {
                                              patientProvider.patientModel =
                                                  patientListModel[
                                                      selectedIndex];
                                              final listPatientHistoryFromDb =
                                                  await DatabaseService
                                                      .getPatientHistoryByRecordNumber(
                                                          patientProvider
                                                              .patientModel!
                                                              .recordNumber);
                                              List<PatientHistoryModel>
                                                  patientHistoryListModel = [];
                                              for (var element
                                                  in listPatientHistoryFromDb) {
                                                patientHistoryListModel.add(
                                                    PatientHistoryModel.fromMap(
                                                        element));
                                              }
                                              patientProvider
                                                      .patientHistoryList =
                                                  patientHistoryListModel;
                                              patientProvider.setState(() {});
                                              modalBottomPatientHistoryList();
                                            } catch (e) {
                                              printDebug(
                                                  'Get patient history error: $e',
                                                  isError: true);
                                            }
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
                                      'EMR',
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
