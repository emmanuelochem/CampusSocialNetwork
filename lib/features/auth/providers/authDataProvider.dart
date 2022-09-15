import 'package:flutter/material.dart';
import 'package:mysocial_app/core/cache/local_cache.dart';
import 'package:mysocial_app/core/logics/generalLogics.dart';
import 'package:mysocial_app/features/auth/api/authApi.dart';
import 'package:recase/recase.dart';

class AuthDataProvider with ChangeNotifier {
  AuthDataProvider(this._localCache);
  final LocalCache _localCache;

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

  Future validateLogin(
      {Map<String, dynamic> data, BuildContext context}) async {
    //print(localCache.fetch('USER'));
    try {
      AuthApi authApi = AuthApi();
      await authApi.validateLogin(data).then((res) async {
        // print(res);
        if (res['status'] != 'success') {
          return GeneralLogics.showAlert(
              title: true,
              titleText: ReCase(res['status']).sentenceCase,
              body: true,
              bodyText: ReCase(res['message']).sentenceCase,
              cancel: true,
              cancelText: 'Retry',
              cancelFunction: () => Navigator.pop(context, null),
              context: context);
        }
        //print(res['user']);
        await _localCache.save('USER', res['user']);
        return 'success';
      });
    } catch (e) {
      return null;
    }
  }
}
