// ignore_for_file: non_constant_identifier_names, empty_catches

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mysocial_app/activity_dashboard.dart';
import 'package:mysocial_app/core/cache/local_cache.dart';
import 'package:mysocial_app/features/auth/view/welcomePage.dart';
import 'package:mysocial_app/features/chat/database/repository/offline_datasource.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';
import 'package:mysocial_app/features/chat/database/repository/db_factory.dart';
import 'package:mysocial_app/features/chat/services/user_service.dart';

import 'package:mysocial_app/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class CompositionRoot {
  static Database _db;
  static LocalCache _localCache;
  static LocalCache get localCache => _localCache;
  static IDatasource _datasource;
  static IDatasource get chatDataSource => _datasource;
  static IUserService _userService;
  static IUserService get userService => _userService;

  static configure() async {
    //await DatabaseClient.instance.removeDatabase();
    _db = await DatabaseClient.instance.database;
    // await _db.delete('chats');
    // await _db.delete('messages');
    _datasource = OfflineDatasource(_db);
    _localCache = LocalCache();
    _userService = UserService();

    try {
      cameras = await availableCameras();
    } catch (e) {
      log('Error in fetching the cameras: $e');
    }
  }

  static Future<Widget> start() async {
    final Map user = await _localCache.fetch('USER');
    return user.isEmpty ? OnboardingUi() : HomeUi(LocalUser.fromMap(user));
  }

  static Widget OnboardingUi() {
    return const WelcomePage();
  }

  static Widget HomeUi(LocalUser me) {
    return const ActivityPage();
  }
}
