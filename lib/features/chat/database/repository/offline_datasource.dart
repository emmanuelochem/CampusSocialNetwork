import 'dart:developer';

import 'package:mysocial_app/features/chat/database/repository/online_datasource.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class IDatasource {
  //Future<void> importChats(List<ChatModel> chat);
  Future<void> addChat(ChatModel chat);
  Future<void> addMessage(MessagesModel message);
  Future<ChatModel> findChat(String chatId);
  Future<List<ChatModel>> findAllChats();
  Future<void> updateMessage(MessagesModel message);
  Future<List<MessagesModel>> findMessages(int chatId);
  Future<void> deleteChat(String chatId);
  Future<void> updateMessageReceipt(String messageId);
}

class OfflineDatasource extends OnlineDatasource implements IDatasource {
  final Database _db;

  OfflineDatasource(this._db);

  @override
  Future<List<ChatModel>> findAllChats() async {
    var offlineData = await _db.transaction((txn) async {
      final offlineChats = await txn.query('chats', orderBy: 'created_at DESC');
      if (offlineChats.isEmpty) return [];
      log('0---------OFFLINE DATA SOURCE-------------0');
      return await Future.wait(
        offlineChats.map<Future<ChatModel>>(
          (row) async {
            final unread = Sqflite.firstIntValue(await txn.rawQuery(
                'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
                [row['chat_id'], 'deliverred']));

            final mostRecentMessage = await txn.query('messages',
                where: 'chat_id = ?',
                whereArgs: [row['chat_id']],
                orderBy: 'created_at DESC',
                limit: 1);

            final chat = ChatModel.fromOfflineMap(row);
            chat.unread = unread;
            if (mostRecentMessage.isNotEmpty) {
              chat.mostRecent = MessagesModel.fromMap(mostRecentMessage.first);
            }
            return chat;
          },
        ),
      );
    });

    if (offlineData.isEmpty) {
      log('0---------ONLINE DATA SOURCE-------------0');
      var onlineData = await findOnlineChats();
      await Future.wait(onlineData.map<Future<void>>((conversation) async {
        //debugPrint(conversation.toString());
        return await addChat(conversation).then(
          (value) async => await addMessage(conversation.mostRecent),
        );
      }));
      return onlineData;
    }

    return offlineData;
  }

  //insert conversation
  @override
  Future<void> addChat(ChatModel conversation) async {
    return await _db.transaction((txn) async {
      await txn.insert(
        'chats',
        conversation.toMap(),
        //conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    });
  }

  @override
  Future<void> addMessage(MessagesModel message) async {
    await _db.transaction((txn) async {
      await txn.insert('messages', message.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      // await txn.update(
      //     'chats', {'updated_at': message.message.timestamp.toString()},
      //     where: 'id = ?', whereArgs: [message.chatId]);
    });
  }

  @override
  Future<List<MessagesModel>> findMessages(int chatId) async {
    var listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );
    print(listOfMaps);
    return listOfMaps
        .map<MessagesModel>((map) => MessagesModel.fromOfflineMap(map))
        .toList();
  }

  @override
  Future<ChatModel> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'chat_id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;
      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'deliverred']));

      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at DESC',
          limit: 1);
      final chat = ChatModel.fromMap(listOfChatMaps.first);
      chat.unread = unread;
      if (mostRecentMessage.isNotEmpty) {
        chat.mostRecent = MessagesModel.fromMap(mostRecentMessage.first);
      }
      return chat;
    });
  }

  @override
  Future<void> updateMessage(MessagesModel message) async {
    await _db.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateMessageReceipt(String messageId) {
    // TODO: implement updateMessageReceipt
    throw UnimplementedError();
  }

  // @override
  // Future<void> importChats(List<ChatModel> chats) async {
  //     await Future.wait(chats.map<Future<void>>((conversation) async {
  //       return await txn.insert(
  //         'chats',
  //         conversation.toMap(),
  //         conflictAlgorithm: ConflictAlgorithm.rollback,
  //       );
  //     }));
  // return await _db.transaction((txn) async {
  //   await txn.rawInsert(
  //       'INSERT INTO chats (id, chat_id, status, created_at) VALUES (?, ?, ?, ?)',
  //       [chat.id, chat.id, chat.status.value(), chat.created_at]);
  // });
  //   await _db.transaction((txn) async {
  //     await Future.wait(chats.map<Future<void>>((conversation) async {
  //       return await txn.insert(
  //         'chats',
  //         conversation.toMap(),
  //         conflictAlgorithm: ConflictAlgorithm.rollback,
  //       );
  //     }));
  //   });
  //}
}
