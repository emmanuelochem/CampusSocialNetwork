import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysocial_app/core/logics/generalLogics.dart';

abstract class BaseApi {
  //final String _serverUrl = 'http://10.0.2.2:8000/api/'; //android
  final String _serverUrl = 'http://127.0.0.1:8000/api/'; //ios

  Future httpGet(
      {String route,
      Map<String, dynamic> header,
      bool hasToken = true,
      bool successSnackbar = false,
      BuildContext context}) async {
    route = _serverUrl + route;
    header['Accept'] = 'application/json';
    header['Connection'] = 'keep-alive';
    header['Content-Type'] = 'application/json';
    if (hasToken) {
      String token = await GeneralLogics.getToken();
      //print(token);
      header['Authorization'] = 'Bearer $token';
    }
    Dio dio = Dio(BaseOptions(
      baseUrl: _serverUrl,
      connectTimeout: 60000,
      receiveTimeout: 60000,
      headers: header,
    ));
    return dio
        .get(
      route,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
    )
        .then((response) {
      if (response != null) {
        if (hasToken && response.data['message'] == 'Unauthenticated.') {
          return 'session_expired';
        }
        return response.data;
      }
      return;
    }).catchError((error) => print(error));
  }

  Future httpPost(
      {String route,
      Map<String, dynamic> data,
      Map<String, dynamic> header,
      bool hasToken = true,
      bool successSnackbar = false,
      BuildContext context}) async {
    route = _serverUrl + route;
    header['Accept'] = 'application/json';
    header['Connection'] = 'keep-alive';
    header['Content-Type'] = 'application/json';
    if (hasToken) {
      String token = await GeneralLogics.getToken();
      header['Authorization'] = 'Bearer $token';
    }
    Dio dio = Dio(BaseOptions(
      baseUrl: _serverUrl,
      connectTimeout: 60000,
      receiveTimeout: 60000,
      headers: header,
    ));
    FormData formData;
    formData = FormData.fromMap(data);
    return dio
        .post(
      route,
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
    )
        .then((response) {
      if (response != null) {
        if (hasToken && response.data['message'] == 'Unauthenticated.') {
          return 'session_expired';
        }
        return response.data;
      }
      return null;
    }).catchError((error) => print(error));
  }

  Future httpDelete(
      {String route,
      Map<String, dynamic> data,
      Map<String, dynamic> header,
      bool hasToken = true,
      bool successSnackbar = false,
      BuildContext context}) async {
    route = _serverUrl + route;
    header['Accept'] = 'application/json';
    header['Connection'] = 'keep-alive';
    header['Content-Type'] = 'application/json';
    if (hasToken) {
      String token = await GeneralLogics.getToken();
      header['Authorization'] = 'Bearer $token';
    }
    Dio dio = Dio(BaseOptions(
      baseUrl: _serverUrl,
      connectTimeout: 60000,
      receiveTimeout: 60000,
      headers: header,
    ));
    FormData formData;
    formData = FormData.fromMap(data);
    return dio
        .delete(
      route,
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
    )
        .then((response) {
      if (response != null) {
        if (hasToken && response.data['message'] == 'Unauthenticated.') {
          return 'session_expired';
        }
        return response.data;
      }
      return null;
    }).catchError((error) => print(error));
  }
}
