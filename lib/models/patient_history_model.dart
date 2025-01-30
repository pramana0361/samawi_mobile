class PatientHistoryModel {
  late int id;
  late int recordNumber;
  late int dateVisit;
  late int registeredBy;
  late int consultationBy;
  late String symptoms;
  late String doctorDiagnose;
  late String icd10Code;
  late String icd10Name;
  late bool isDone;

  PatientHistoryModel({
    required this.id,
    required this.recordNumber,
    required this.dateVisit,
    required this.registeredBy,
    required this.consultationBy,
    required this.symptoms,
    required this.doctorDiagnose,
    required this.icd10Code,
    required this.icd10Name,
    required this.isDone,
  });

  factory PatientHistoryModel.fromMap(Map<String, dynamic> map) {
    var id = map['id'];
    var recordNumber = map['record_number'];
    var dateVisit = map['date_visit'];
    var registeredBy = map['registered_by'];
    var consultationBy = map['consultation_by'];
    var symptoms = map['symptoms'];
    var doctorDiagnose = map['doctor_diagnose'];
    var icd10Code = map['icd_10_code'];
    var icd10Name = map['icd_10_name'];
    var isDone = map['is_done'] > 0 ? true : false;
    return PatientHistoryModel(
      id: id,
      recordNumber: recordNumber,
      dateVisit: dateVisit,
      registeredBy: registeredBy,
      consultationBy: consultationBy,
      symptoms: symptoms,
      doctorDiagnose: doctorDiagnose,
      icd10Code: icd10Code,
      icd10Name: icd10Name,
      isDone: isDone,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'record_number': recordNumber,
        'date_visit': dateVisit,
        'registered_by': registeredBy,
        'consultation_by': consultationBy,
        'symptoms': symptoms,
        'doctor_diagnose': doctorDiagnose,
        'icd_10_code': icd10Code,
        'icd_10_name': icd10Name,
        'is_done': isDone == true ? 1 : 0,
      };
}
