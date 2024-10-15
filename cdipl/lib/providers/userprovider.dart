import 'package:cdipl/helpers/tokenmanager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usermodel.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? token;
  User? get user => _user; // Define a getter for _user

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setToken(newtoken) {
    token = newtoken;
    // notifyListeners();
  }

  void logout() async {
    await TokenManager.removeToken();
    token = null;
    _user = null;
    notifyListeners();
  }
}
