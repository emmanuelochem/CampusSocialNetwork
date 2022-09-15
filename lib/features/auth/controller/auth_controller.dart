import 'package:flutter/material.dart';
import 'package:mysocial_app/core/logics/generalLogics.dart';
import 'package:mysocial_app/features/auth/auth.dart';
import 'package:recase/recase.dart';

class AuthController {
  Future login({Map<String, dynamic> data, BuildContext context}) async {
    try {
      AuthApi authApi = AuthApi();
      var res = await authApi.login(data);
      print(res);
      if (res['status'] != 'success') {
        return GeneralLogics.showAlert(
            title: true,
            titleText: ReCase(res['status']).sentenceCase,
            body: true,
            bodyText: ReCase(res['message']).sentenceCase,
            cancel: true,
            cancelText: 'Retry',
            cancelFunction: () => Navigator.pop(context),
            context: context);
      }
      return res['status'];
    } catch (e) {
      return null;
    }
  }
}
