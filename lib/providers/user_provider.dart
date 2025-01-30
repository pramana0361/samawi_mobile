import 'package:flutter/material.dart';
import 'package:simawi_mobile/models/user_model.dart';
import 'package:simawi_mobile/utils/enums.dart';

class UserProvider extends ChangeNotifier {
  late UserModel user;
  late String accessToken;

  UserProvider() {
    user = UserModel(
        id: 0,
        email: '',
        password: '',
        name: '',
        role: Role.admin,
        createdAt: 0,
        updatedAt: 0);
    accessToken = '';
  }

  void setState(VoidCallback func) {
    func;
    notifyListeners();
  }
}
