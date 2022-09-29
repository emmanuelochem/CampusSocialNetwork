import 'package:mysocial_app/features/chat/repository/offline_datasource.dart';
import 'package:sqflite/sqflite.dart';

class ChatService extends OfflineDatasource {
  ChatService(Database db) : super(db);
}
