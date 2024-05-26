import 'package:app_task_manager/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_task_manager/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<bool> login(String username, String password) async {
    _user = await ApiService().login(username, password);
    notifyListeners();
    return _user != null;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
