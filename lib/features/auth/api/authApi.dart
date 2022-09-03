import 'package:mysocial_app/core/api/network_handler.dart';

class AuthApi extends BaseApi {
  Future verifyPhone(Map data) async {
    String route = 'auth/verify-phone';
    Map<String, dynamic> header = {};
    return await httpPost(
        route: route, data: data, header: header, hasToken: false);
  }

  Future verifyPhoneToken(Map data) async {
    String route = 'auth/verify-phone-otp';
    Map<String, dynamic> header = {};
    return await httpPost(
        route: route, data: data, header: header, hasToken: false);
  }

  Future getDepartment() async {
    String route = 'unprotected/departments';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: false);
  }

  Future getDepartmentLevels(int id) async {
    String route = 'unprotected/department/$id/levels';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: false);
  }

  Future register(Map data) async {
    String route = 'auth/register';
    Map<String, dynamic> header = {};
    return await httpPost(
        route: route, data: data, header: header, hasToken: false);
  }

  Future login(Map data) async {
    String route = 'auth/login';
    Map<String, dynamic> header = {};
    return await httpPost(
        route: route, data: data, header: header, hasToken: false);
  }

  Future validateLogin(Map data) async {
    String route = 'auth/verify-login';
    Map<String, dynamic> header = {};
    return await httpPost(
        route: route, data: data, header: header, hasToken: false);
  }
}
