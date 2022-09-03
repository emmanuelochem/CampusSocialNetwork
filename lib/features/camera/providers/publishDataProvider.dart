import 'package:flutter/material.dart';

class PublishDataProvider with ChangeNotifier {
  Map _audience;
  Map get audience => _audience;
  set setAudience(Map data) {
    _audience = data;
    notifyListeners();
  }

  //   String _audience;
  // String get audience => _audience;
  // set setAudience(String data) {
  //   _audience = data;
  //   notifyListeners();
  // }
}
