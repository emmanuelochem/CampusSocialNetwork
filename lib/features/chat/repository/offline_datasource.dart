import 'dart:developer';

import 'package:mysocial_app/features/chat/repository/online_datasource.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDatasource extends OnlineDatasource {
  final Database _db;
  OfflineDatasource(this._db);

  Future<List<ChatModel>> findAllChats() async {
    var offlineData = await _db.transaction((txn) async {
      final offlineChats = await txn.query('chats', orderBy: 'created_at DESC');
      if (offlineChats.isEmpty) return [];
      log('--OFFLINE DATA SOURCE--');
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
      log('--ONLINE DATA SOURCE--');
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

  Future<void> addChat(ChatModel conversation) async {
    return await _db.transaction((txn) async {
      await txn.insert(
        'chats',
        conversation.toMap(),
        //conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    });
  }

  Future<int> addMessage(MessagesModel message) async {
    return await _db.transaction((txn) async {
      return await txn.insert('messages', message.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      // await txn.update(
      //     'chats', {'updated_at': message.message.timestamp.toString()},
      //     where: 'id = ?', whereArgs: [message.chatId]);
    });
  }

  Future<List<MessagesModel>> findMessages(int chatId) async {
    var listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );
    //log(listOfMaps.toString());
    return listOfMaps
        .map<MessagesModel>((map) => MessagesModel.fromOfflineMap(map))
        .toList();
  }

  Future<MessagesModel> addNewChat(MessagesModel message) async {
    if (!await _isExistingChat(message.chat_id)) {
      final chat = ChatModel(chat_id: message.chat_id, membersId: [
        {'id': message.receiver_id}
      ]);
      await createNewChat(chat);
    }
    var msgID = await addMessage(message);
    //log(msgID.toString());
    return await getMessageByID(msgID);
  }

  Future<MessagesModel> getMessageByID(int messageId) async {
    final listOfMaps = await _db.transaction((txn) async {
      return await txn.query(
        'messages',
        where: 'id = ?',
        whereArgs: [messageId],
      );
    });
    //log(listOfMaps.toString());
    return MessagesModel.fromOfflineMap(listOfMaps.first);
  }

  Future<bool> _isExistingChat(int chatId) async {
    final listOfChatMaps = await _db.transaction((txn) async {
      return await txn.query(
        'chats',
        where: 'chat_id = ?',
        whereArgs: [chatId],
        limit: 1,
      );
    });
    return listOfChatMaps.isEmpty ? false : true;
  }

  Future<void> createNewChat(ChatModel chat) async {
    await addChat(chat);
  }

  Future<List<ChatModel>> getNewChats() async {
    log('0---------NEW ONLINE CHAT-------------0');
    var newChats = await getOnlineNewChats();
    if (newChats.isNotEmpty) {
      await Future.forEach(newChats, (ChatModel chat) async {
        await addNewChat(chat.mostRecent);
      });
    }
    return newChats;
  }

  Future<ChatModel> findChat(int chatId) async {
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

  Future<MessagesModel> updateMessage(MessagesModel message) async {
    await _db.update(
      'messages',
      message.toMap(),
      where: 'message_uuid = ?',
      whereArgs: [message.message_uuid],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return await getMessageByUUID(message.message_uuid);
  }

  Future<MessagesModel> getMessageByUUID(String messageUuId) async {
    final listOfMaps = await _db.transaction((txn) async {
      return await txn.query(
        'messages',
        where: 'message_uuid = ?',
        whereArgs: [messageUuId],
      );
    });
    //log(listOfMaps.toString());
    return MessagesModel.fromOfflineMap(listOfMaps.first);
  }

  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'chat_id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  Future<void> updateMsg(MessagesModel message) async {
    return await _db.update(
      'messages',
      message.toMap(),
      where: 'uuid = ?',
      whereArgs: [message.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //
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
