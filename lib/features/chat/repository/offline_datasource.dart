import 'dart:developer';

import 'package:mysocial_app/features/chat/models/chat_user_relation_table.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';
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
            final chat = ChatModel.fromOfflineMap(row);
            //find recipient
            final chatRecipient = await txn.query(
              'chat_user',
              where: 'chat_id = ?',
              whereArgs: [row['chat_id']],
              limit: 1,
            );
            var usr = ChatUserRelation.fromMap(chatRecipient.first);
            final onlUsr = await fetchChatUserOnline(userId: usr.user_id);
            if (onlUsr != null) {
              chat.users = onlUsr;
            } else {
              final offlineUser = await txn.query(
                'users',
                where: 'user_id = ?',
                whereArgs: [usr.user_id],
                limit: 1,
              );
              //log(offlineUser.toString());
              chat.users = UserModel.fromOfflineMap(offlineUser.first);
            }

            //count unread messages
            final unread = Sqflite.firstIntValue(await txn.rawQuery(
                'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
                [row['chat_id'], 'deliverred']));
            chat.unread = unread;

            //find last message
            final mostRecentMessage = await txn.query('messages',
                where: 'chat_id = ?',
                whereArgs: [row['chat_id']],
                orderBy: 'created_at DESC',
                limit: 1);
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
      List<ChatModel> onlineData = await findOnlineChats();
      await Future.wait(onlineData.map<Future<void>>((chat) async {
        return await addChat(chat).then(
          (value) async {
            await addChatUser(chat.users);
            await addChatUserRelation(chat);
            await addMessage(chat.mostRecent);
          },
        );
      }));
      return onlineData;
    }

    return offlineData;
  }

  // Future<UserModel> fetchChatUsers({int chatId}) async {
  //   final chatRecipient = await _db.transaction((txn) async {
  //     return await txn.query('chat_user',
  //         where: 'chat_id = ?',
  //         whereArgs: [chatId],
  //         orderBy: 'created_at DESC',
  //         limit: 1);
  //   });
  //   return UserModel.fromOnlineMap(chatRecipient.first);
  // }

  // Future<UserModel> fetchChatUserOffline({int userId}) async {
  //   final chatRecipient = await _db.transaction((txn) async {
  //     return await txn.query('users',
  //         where: 'user_id = ?',
  //         whereArgs: [userId],
  //         //orderBy: 'created_at DESC',
  //         limit: 1);
  //   });
  //   return UserModel.fromOnlineMap(chatRecipient.first);
  // }

  Future<int> addChatUserRelation(
    ChatModel chat,
  ) async {
    //group chat loop support
    //  await Future.forEach(chat.users, (ChatModel chat) async {
    ChatUserRelation relation =
        ChatUserRelation(chat_id: chat.chat_id, user_id: chat.users.user_id);
    return await _db.transaction((txn) async {
      return await txn.insert(
        'chat_user',
        relation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    // });
  }

  Future<void> addChatUser(UserModel user) async {
    return await _db.transaction((txn) async {
      await txn.insert(
        'users',
        user.toMap(),
        //conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    });
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
      final chat = ChatModel(
        chat_id: message.chat_id,
        // users: [
        //   {'id': message.receiver_id}
        // ],
      );
      await createNewChat(chat);
    }
    var msgID = await addMessage(message);
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
    //await addChatUserRelation(chat);
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
      final chat = ChatModel.fromOnlineMap(listOfChatMaps.first);
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

  Future<UserModel> getUserByID({int userId}) async {
    final listOfUser = await _db.transaction((txn) async {
      return await txn.query(
        'users',
        where: 'user_id = ?',
        whereArgs: [userId],
        limit: 1,
      );
    });
    //log(listOfUser.toString());
    return UserModel.fromOfflineMap(listOfUser.first);
  }
}
