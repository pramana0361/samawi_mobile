import 'package:flutter/material.dart';
import 'package:simawi_mobile/models/patient_history_model.dart';
import 'package:simawi_mobile/models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  PatientModel? patientModel;
  List<PatientHistoryModel> patientHistoryList = [];

  void setState(VoidCallback func) {
    func;
    notifyListeners();
  }
}
