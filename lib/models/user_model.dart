import 'package:simawi_mobile/utils/enums.dart';

class UserModel {
  late int id;
  late String email;
  late String password;
  late String name;
  late Role role;
  late int createdAt;
  late int updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    var id = map['id'];
    var email = map['email'];
    var password = map['password'];
    var name = map['name'];
    var role = Role.values.byName(map['role']);
    var createdAt = map['created_at'];
    var updatedAt = map['updated_at'];
    return UserModel(
      id: id,
      email: email,
      password: password,
      name: name,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'password': password,
        'name': name,
        'role': role.name,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
