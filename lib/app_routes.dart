import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysocial_app/features/auth/view/loginPage.dart';
import 'package:mysocial_app/features/auth/view/registerPage.dart';
import 'package:mysocial_app/features/auth/view/welcomePage.dart';
import 'package:mysocial_app/features/camera/views/camera_screen.dart';
import 'package:mysocial_app/features/camera/views/gallery_screen.dart';
import 'package:mysocial_app/home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  //final _parameters = settings.arguments as Map<String, dynamic>;
  switch (settings.name) {
    case '/welcome':
      return MaterialPageRoute(
        builder: (context) => const WelcomePage(),
      );
      break;
    case '/register':
      return MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      );
      break;
    case '/login':
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
      break;
    case '/home':
      return MaterialPageRoute(
        builder: (context) => const ActivityPage(),
      );
      break;
    case '/camera':
      return MaterialPageRoute(
        builder: (context) => CameraScreen(),
      );
      break;
    case '/gallery':
      return MaterialPageRoute(
        builder: (context) => GalleryScreen(),
      );
      break;
    default:
      return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return CupertinoPageRoute(builder: (_) {
    return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text("Page Not Found"),
        ));
  });
}
