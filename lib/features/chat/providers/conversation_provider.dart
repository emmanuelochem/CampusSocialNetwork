import 'package:flutter/material.dart';
import 'package:mysocial_app/core/cache/local_cache.dart';
import 'package:mysocial_app/features/chat/database/repository/offline_datasource.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/services/user_service.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';

class ChatsProvider with ChangeNotifier {
  final IDatasource _chatService;
  final IUserService _userService;
  final LocalCache _localCache;

  ChatsProvider(this._chatService, this._userService, this._localCache) {
    //listenToMessages();
  }

  hdjd() async {
    var userInstance = await _localCache.fetch('USER');
  }

  List<ChatModel> _conversations = [];
  List<ChatModel> get conversations => _conversations;
  Future<List<ChatModel>> getChats() async {
    _conversations = [];
    var chats = await _chatService.findAllChats();
    await Future.forEach(chats, (ChatModel chat) async {
      final ids = chat.membersId.map<int>((e) => e.values.first).toList();
      final users = await _userService.fetch(ids);
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

  // LaravelFlutterPusher getPusherClient() {
  //   PusherOptions options = PusherOptions(
  //     host: '127.0.0.1',
  //     port: 6001,
  //     cluster: 'mt1',
  //     encrypted: false,
  //     auth: PusherAuth(
  //       "http://127.0.0.1:8000/api/broadcasting/auth",
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //     ),
  //   );
  //   return LaravelFlutterPusher(
  //     'ABCDEF',
  //     options,
  //     enableLogging: true,
  //     onConnectionStateChange: (state) {
  //       log(state.currentState);
  //     },
  //     onError: (error) {
  //       log(error.exception);
  //     },
  //   );
  // }

  // Echo echoSetup({LaravelFlutterPusher client}) {
  //   return Echo({
  //     'broadcaster': 'pusher',
  //     'client': client,
  //     "wsHost": '127.0.0.1',
  //     "httpHost": '127.0.0.1',
  //     "wsPort": 6001,
  //     'auth': {
  //       "headers": {'Authorization': 'Bearer $token'}
  //     },
  //     'authEndpoint': 'http://127.0.0.1:8000/api/broadcasting/auth',
  //     "disableStats": true,
  //     "forceTLS": false,
  //     "enabledTransports": ['ws', 'wss']
  //   });
  // }

  // void listenToMessages() {
  //   LaravelFlutterPusher pusherClient = getPusherClient();
  //   Echo echo = echoSetup(client: pusherClient);
  //   echo.private('home').listen('NewMessage', (event) {
  //     Map data = jsonDecode(event['message']);
  //     MessagesModel message = MessagesModel();
  //     message.body = data['content'];
  //     message.userId = data['sender_id'];
  //     _messages.add(message);
  //     for (int i = 0; i < conversations.length; i++) {
  //       if (conversations[i].id == data['conversation_id']) {
  //         _conversations[i].last_message = data;
  //         _conversations[i].created_at = data['created_at'];
  //         notifyListeners();
  //         //send a reply back to the server that it has been delivered
  //       }
  //     }
  //     notifyListeners();
  //   });
  // }

  // Future<List<MessagesModel>> getMessages(int id) async {
  //   _messages = [];
  //   var response = await _messagesService.getMessages(id);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     data['data'].forEach(
  //         (conversaion) => _messages.add(MessagesModel.fromJson(conversaion)));
  //     notifyListeners();
  //   }
  //   return _messages;
  // }

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
