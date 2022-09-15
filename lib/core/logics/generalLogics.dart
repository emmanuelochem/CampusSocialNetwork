import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralLogics {
  static Future<void> removeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static void logoutFunction(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
    GeneralLogics.removeUserData();
  }

  // static Future<void> refreshUserData(
  //     BuildContext context, UserDataProvider userDataProvider) async {
  //   // var token = await GeneralLogics.getToken();
  // if (token == null) {
  // GeneralLogics.showMessage(
  //     'Your session has expired, please login again.', Colors.red, context);
  // GeneralLogics.logoutFunction(context);
  // } else {
  //UserAccountApi request = UserAccountApi(token: token);
  //request.getUserData(context).then((res) {
  // print(res['data']);
  //if (res != null) {
  // GeneralLogics.setUserDataProvider(userDataProvider, res['data']);
  // GeneralLogics.showMessage(
  //     'Page refresh successful!', Colors.green, context);
  // } else {
  //  Navigator.pushReplacementNamed(context, '/login');
  // }
  //});
  // }
  //}
  // }
//
  // static void setUserDataProvider(UserDataProvider userDataProvider, Map data) {
  //   userDataProvider.profile = data['user'];
  // }

  static Future showAlert(
      {bool dismissible = true,
      bool title = false,
      String titleText,
      bool body = false,
      String bodyText,
      bool footer = false,
      String footerText,
      bool cancel = false,
      String cancelText,
      Function cancelFunction,
      bool okay = false,
      String okayText,
      Function okayFunction,
      BuildContext context}) {
    return showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  (title)
                      ? Text(titleText, style: const TextStyle(fontSize: 14))
                      : const SizedBox(),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  (body)
                      ? Text(bodyText,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500))
                      : const SizedBox(),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  (footer)
                      ? Text(footerText,
                          style: const TextStyle(
                            fontSize: 12,
                          ))
                      : const SizedBox(),
                ])),
            actions: [
              (cancel)
                  ? TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(cancelText))
                  : const SizedBox(),
              (okay)
                  ? TextButton(onPressed: okayFunction, child: Text(okayText))
                  : const SizedBox(),
            ],
          );
        });
  }
}
