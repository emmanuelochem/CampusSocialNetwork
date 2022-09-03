import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/features/auth/api/userApi.dart';
import 'package:mysocial_app/core/logics/generalLogics.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool isStarting = true;
  Future<void> pageLoaded(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () async {
      var token = await GeneralLogics.getToken();
      if (token != null) {
        UserApi request = UserApi();
        await request.ping().then((res) {
          if (res['status'] == 'connected') {
            //GeneralLogics.setUserDataProvider(appProvider, res['data']);
            return Navigator.pushReplacementNamed(context, '/home');
          }
          GeneralLogics.removeUserData();
          return Navigator.pushReplacementNamed(context, '/welcome');
        });
      }
      return Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isStarting) {
      pageLoaded(context);
      isStarting = false;
    }
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                PhosphorIcons.chats_circle_fill,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
