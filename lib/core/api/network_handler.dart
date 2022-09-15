import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysocial_app/core/cache/local_cache.dart';

class Endpoints {
  Endpoints._();

  // base url

  // static const bool _staging = true;
  // final bool isAndroid = (Platform.isAndroid);
  // static const String baseUrl = _staging
  //     ? "https://reqres.in/api"
  //     : Platform.isAndroid
  //         ? 'http://127.0.0.1:8000/api/'
  //         : 'http://127.0.0.1:8000/api/';

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;
}

abstract class BaseApi {
  final LocalCache _userCache = LocalCache();

  //final String _serverUrl = 'http://10.0.2.2:8000/api/'; //android
  final String _serverUrl = 'http://127.0.0.1:8000/api/'; //ios
  final Map<String, dynamic> _headerContent = {
    'Accept': 'application/json',
    'Connection': 'keep-alive',
    'Content-Type': 'application/json',
  };
  Future httpGet(
      {String route,
      Map<String, dynamic> header,
      bool hasToken = true,
      bool successSnackbar = false,
      BuildContext context}) async {
    route = _serverUrl + route;
    header.addAll(_headerContent);
    if (hasToken) {
      var user = await _userCache.fetch('USER');
      header['Authorization'] = 'Bearer ${user['token']}';
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
    }).catchError((error) => log(error));
  }

  Future httpPost(
      {String route,
      Map<String, dynamic> data,
      Map<String, dynamic> header,
      bool hasToken = true,
      bool successSnackbar = false,
      BuildContext context}) async {
    route = _serverUrl + route;
    header.addAll(_headerContent);
    if (hasToken) {
      var user = await _userCache.fetch('USER');
      header['Authorization'] = 'Bearer ${user['token']}';
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
    }).catchError((error) => log(error));
  }

  Future httpDelete(
      {String route,
      Map<String, dynamic> data,
      Map<String, dynamic> header,
      bool hasToken = true,
      bool successSnackbar = false,
      BuildContext context}) async {
    route = _serverUrl + route;
    header.addAll(_headerContent);
    if (hasToken) {
      var user = await _userCache.fetch('USER');
      header['Authorization'] = 'Bearer ${user['token']}';
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
    }).catchError((error) => log(error));
  }
}
