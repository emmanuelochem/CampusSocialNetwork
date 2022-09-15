import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  Future fetch(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString(key) ?? '{}');
  }

  Future save(String key, Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }
}
