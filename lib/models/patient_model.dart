import 'package:simawi_mobile/utils/enums.dart';

class PatientModel {
  late int id;
  late int recordNumber;
  late String name;
  late DateTime birth;
  late String nik;
  late String phone;
  late String address;
  late BloodType bloodType;
  late double weight;
  late double height;
  late int createdAt;
  late int updatedAt;

  PatientModel({
    required this.id,
    required this.recordNumber,
    required this.name,
    required this.birth,
    required this.nik,
    required this.phone,
    required this.address,
    required this.bloodType,
    required this.weight,
    required this.height,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    var id = map['id'];
    var recordNumber = map['record_number'];
    var name = map['name'];
    var birth = DateTime.parse(map['birth']);
    var nik = map['nik'];
    var phone = map['phone'];
    var address = map['address'];
    var bloodType = BloodType.values.byName(map['blood_type']);
    var weight = map['weight'];
    var height = map['height'];
    var createdAt = map['created_at'];
    var updatedAt = map['updated_at'];
    return PatientModel(
      id: id,
      recordNumber: recordNumber,
      name: name,
      birth: birth,
      nik: nik,
      phone: phone,
      address: address,
      bloodType: bloodType,
      weight: weight,
      height: height,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'record_number': recordNumber,
        'name': name,
        'birth': birth.toString(),
        'nik': nik,
        'phone': phone,
        'address': address,
        'blood_type': bloodType.name,
        'weight': weight,
        'height': height,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
