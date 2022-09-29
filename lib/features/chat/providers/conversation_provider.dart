import 'package:flutter/material.dart';
import 'package:mysocial_app/core/cache/local_cache.dart';
import 'package:mysocial_app/features/chat/services/chat_service.dart';
import 'package:mysocial_app/features/chat/services/websocket_service.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/services/user_service.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:uuid/uuid.dart';

class ChatsProvider with ChangeNotifier {
  final ChatService _chatService;
  final UserService _userService;
  final LocalCache _localCache;
  final SocketService _socketService;

  ChatsProvider(this._chatService, this._userService, this._localCache,
      this._socketService) {
    init();
  }

// ignore: prefer_typing_uninitialized_variables
  var userInstance;
  init() async {
    userInstance = await _localCache.fetch('USER');
    await getChats();
    await _socketService.connect();
    await _socketService.goOnline();
    //await _socketService.goOffline();
    var res =
        await _socketService.streamChat(channel: 'home', event: 'NewMessage');
    print(res.toString());
  }

  List<ChatModel> _conversations = [];
  List<ChatModel> get conversations => _conversations;
  Future<List<ChatModel>> getChats() async {
    _conversations = [];
    var chats = await _chatService.findAllChats();
    await Future.forEach(chats, (ChatModel chat) async {
      final ids = chat.membersId.map<int>((e) => e.values.first).toList();
      final users = await _chatService.fetchChatUser(ids);
      chat.users = users;
      _conversations.add(chat);
    });
    notifyListeners();
    return _conversations;
  }

  List<MessagesModel> _messages = [];
  List<MessagesModel> get messages => _messages;
  Future<List<MessagesModel>> getMessages({int chatId = 0}) async {
    _messages = [];
    var msg = await _chatService.findMessages(chatId);
    await Future.forEach(msg, (MessagesModel message) async {
      _messages.add(message);
    });
    notifyListeners();
    return _messages;
  }

  Future<void> sendMessage({Map<String, dynamic> message, int chatId}) async {
    var uuid = const Uuid().v1();
    var uniqueId = 'SALM_${chatId}_${userInstance['id']}_$uuid';
    MessagesModel _msg = MessagesModel();
    _msg.chat_id = chatId;
    _msg.message_uuid = uniqueId;
    _msg.sender_id = userInstance['id'];
    _msg.receiver_id = message['receiver_id'];
    _msg.content = message['content'];
    _msg.receipt = 'pending';
    _msg.is_deleted = 0;
    _msg.created_at = message['time'];
    _msg.updated_at = message['time'];
    _msg.is_mine = 'true';
    var response = await _chatService.addNewChat(_msg);
    // log(res.toString());
    _messages.add(response);
    notifyListeners();
    var _onlineMsg = await _chatService.dispatchMessage(response.toMap());
    var _localMsg = await _chatService.updateMessage(_onlineMsg);
    var _item = _messages.indexWhere(
        (element) => element.message_uuid == _localMsg.message_uuid);
    _messages[_item].receipt = _localMsg.receipt;
    notifyListeners();
    //update chat list
  }

  // Future<void> offlineMessage(Map msg) async {
  //   MessagesModel offlineMsg = MessagesModel.fromMap(msg);
  //   await _chatService.addMessage(offlineMsg);
  //   //local notification
  // }

  // Map data = jsonDecode(res['message']);
  // MessagesModel _message = MessagesModel.fromMap(data);
  //save to offline db
  // await _chatService.addMessage(_message);
  //get the refresh the particular conversation

  // message.body = data['content'];
  // message.userId = data['sender_id'];
  // _messages.add(message);
  // for (int i = 0; i < conversations.length; i++) {
  //   if (conversations[i].id == data['conversation_id']) {
  //     _conversations[i].last_message = data;
  //     _conversations[i].created_at = data['created_at'];
  //     notifyListeners();
  //     //send a reply back to the server that it has been delivered
  //   }
  // }
  //notifyListeners();

//   Future<void> fetchOnlineChats() async {
// //background service
//     var newChats = await _chatService.getNewChats();
//     if (newChats.isNotEmpty) {
//       return await getChats();
//     }
//   }

  // Future<MessagesModel> sendMessage(String body, int conversationId) async {
  //   var response = await _messagesService.storeMessagte(body, conversationId);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     MessagesModel message = MessagesModel();
  //     message.body = data['data']['body'];
  //     message.userId = data['data']['user_id'];
  //     for (int i = 0; i < conversations.length; i++) {
  //       if (conversations[i].id == conversationId) {
  //         //conversations[i].last_message = body;
  //         conversations[i].created_at = data['data']['created_at'];
  //       }
  //     }
  //     notifyListeners();
  //     return message;
  //   } else {
  //     return null;
  //   }
  // }

}
