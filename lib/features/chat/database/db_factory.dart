import 'dart:developer';
import 'dart:io';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TableBuilder {
  static const integerPrimaryKey = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const integer = 'INTEGER NOT NULL';
  static const integerNull = 'INTEGER NULL';
  static const integerUnique = 'INTEGER NOT NULL UNIQUE';

  static const text = 'TEXT NOT NULL';
  static const textNull = 'TEXT NULL';

  static const bool = 'BOOLEAN NOT NULL';
  static const boolNull = 'BOOLEAN NULL';

  static const time = 'TIMESTAMP NOT NULL';
  static const timeNull = 'TIMESTAMP NULL';
}

class DatabaseClient {
  // make this a singleton class
  DatabaseClient._privateConstructor();
  static final DatabaseClient instance = DatabaseClient._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db on setup
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String appDir = '${extDir.path}/CatchUp/Databases';
    var folder = await Directory(appDir).create(recursive: true);
    String dbPath = join(folder.path, 'catchup.db');
    var database = await openDatabase(
      dbPath,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: populateDb,
    );
    return database;
  }

  static Future _onConfigure(Database db) async {
    //await db.execute('PRAGMA foreign_keys = ON');
  }

  void populateDb(Database db, int version) async {
    await _createUserTable(db);
    await _createChatTable(db);
    await _createMessagesTable(db);
  }

  _createUserTable(Database db) async {
    log('creating users table.');
    await db
        .execute(
          """
    CREATE TABLE ${UserFields.usersTable} (
  ${UserFields.id} ${TableBuilder.integerPrimaryKey},
  ${UserFields.userId} ${TableBuilder.textNull},
  ${UserFields.nickname} ${TableBuilder.textNull},
  ${UserFields.phone} ${TableBuilder.textNull},
  ${UserFields.photo} ${TableBuilder.textNull},
  ${UserFields.is_self} ${TableBuilder.textNull},
  ${UserFields.is_followed} ${TableBuilder.textNull},
  ${UserFields.is_crush} ${TableBuilder.textNull},
  ${UserFields.levels} ${TableBuilder.textNull},
  ${UserFields.departments} ${TableBuilder.textNull}
  );
""",
        )
        .then((_) => log('users table created.'))
        .catchError((e) => log('error creating conversations table: $e'));
  }

  _createChatTable(Database db) async {
    log('creating conversations table.');
    await db
        .execute(
          """
    CREATE TABLE ${ChatFields.TableName} (
  ${ChatFields.id} ${TableBuilder.integerPrimaryKey},
  ${ChatFields.chatId} ${TableBuilder.integer},
  ${ChatFields.status} ${TableBuilder.text},
   ${ChatFields.members} ${TableBuilder.textNull},
  ${ChatFields.createdAt} ${TableBuilder.time}
  );
  ALTER TABLE `${ChatFields.TableName}`
    ADD UNIQUE (${ChatFields.chatId});
""",
        )
        .then((_) => log('conversations table created.'))
        .catchError((e) => log('error creating conversations table: $e'));
  }

  _createMessagesTable(Database db) async {
    log('creating messages table.');
    await db
        .execute(
          """
      CREATE TABLE ${MessagesFields.TableName} (
  ${MessagesFields.id} ${TableBuilder.integerPrimaryKey},
  ${MessagesFields.conversationId} ${TableBuilder.integer},
  ${MessagesFields.messageId} ${TableBuilder.integerNull},
  ${MessagesFields.messageUuid} ${TableBuilder.text},
  ${MessagesFields.senderId} ${TableBuilder.integer},
  ${MessagesFields.receiverId} ${TableBuilder.integer},
  ${MessagesFields.content} ${TableBuilder.text},
  ${MessagesFields.receipt} ${TableBuilder.text},
  ${MessagesFields.isMine} ${TableBuilder.integer},
  ${MessagesFields.isDeleted} ${TableBuilder.integer},
  ${MessagesFields.createdAt} ${TableBuilder.time},
  ${MessagesFields.updatedAt} ${TableBuilder.time}
      );
  """,
        )
        .then((_) => log('messages table created'))
        .catchError((e) => log('error creating messages table: $e'));
  }

  Future<void> removeDatabase() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String appDir = '${extDir.path}/CatchUp/Databases/catchup.db';
    log('deleting database');
    await deleteDatabase(appDir).then((value) {
      log('database delete coomplete');
    }).catchError((e) => log('error deleting database: $e'));
  }

//offline tasks table
//fail jobs table
}
