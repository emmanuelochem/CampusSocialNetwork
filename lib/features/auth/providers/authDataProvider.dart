import 'package:flutter/material.dart';

class AuthDataProvider with ChangeNotifier {
  String _phone;
  String get phone => _phone;
  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  String _otp;
  String get otp => _otp;
  set otp(String value) {
    _otp = value;
    notifyListeners();
  }

  String _page = 'phone';
  String get page => _page;
  set page(String value) {
    _page = value;
    notifyListeners();
  }

  bool _isMale = true;
  bool get isMale => _isMale;
  set isMale(bool value) {
    _isMale = value;
    notifyListeners();
  }

  int _department;
  int get department => _department;
  set department(int value) {
    _department = value;
    notifyListeners();
  }

  int _level;
  int get level => _level;
  set level(int value) {
    _level = value;
    notifyListeners();
  }

  String _nickname;
  String get nickname => _nickname;
  set nickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  String _loginPage = 'phone';
  String get loginPage => _loginPage;
  set loginPage(String value) {
    _loginPage = value;
    notifyListeners();
  }

  String _loginPhone;
  String get loginPhone => _loginPhone;
  set loginPhone(String value) {
    _loginPhone = value;
    notifyListeners();
  }
}
