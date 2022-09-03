import 'package:flutter/material.dart';

class UserDataProvider with ChangeNotifier {
  Map _profile;
  Map get profile => _profile;
  set profile(Map data) {
    _profile = data;
    notifyListeners();
  }
}
