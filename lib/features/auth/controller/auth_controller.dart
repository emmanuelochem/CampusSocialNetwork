import 'package:flutter/material.dart';
import 'package:mysocial_app/core/logics/generalLogics.dart';
import 'package:mysocial_app/features/auth/auth.dart';
import 'package:recase/recase.dart';

class AuthController {
  Future login({Map<String, dynamic> data, BuildContext context}) async {
    try {
      AuthApi authApi = AuthApi();
      var res = await authApi.login(data);
      //print(res);
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
      return 'proceed';
    } catch (e) {
      return null;
    }
  }

  Future validateLogin(
      {Map<String, dynamic> data,
      UserDataProvider userDataProvider,
      BuildContext context}) async {
    try {
      AuthApi authApi = AuthApi();
      await authApi.validateLogin(data).then((res) {
        //print(res);
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
        GeneralLogics.saveToken(res['token']);
        GeneralLogics.setUserDataProvider(userDataProvider, res['user']);
        Navigator.pushReplacementNamed(context, '/home');
      });
    } catch (e) {
      return null;
    }
  }
}
