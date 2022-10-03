import 'package:flutter/material.dart';
import 'package:mysocial_app/core/cache/local_cache.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';
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
    _listenToChats();
  }

  List<ChatModel> _conversations = [];
  List<ChatModel> get conversations => _conversations;
  Future<List<ChatModel>> getChats() async {
    _conversations = [];
    var chats = await _chatService.findAllChats();
    await Future.forEach(chats, (ChatModel chat) async {
      // final ids = chat.users.map<int>((e) => e.values.first).toList();
      // final users = await _chatService.fetchChatUser(ids);
      // chat.users = users;
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
    MessagesModel response = await _chatService.addNewChat(_msg);
    await updateMessages(response);
    await updateLastMessages(response);
    MessagesModel _onlineMsg =
        await _chatService.dispatchMessage(response.toMap());
    MessagesModel _localMsg = await _chatService.updateMessage(_onlineMsg);
    await updateSentMessage(_localMsg);
  }

  void _listenToChats() {
    _socketService.streamEvent.private('home').listen('NewMessage',
        (event) async {
      MessagesModel _msg = MessagesModel.fromJson(event['message']);
      MessagesModel response = await _chatService.addNewChat(_msg);
      if (_messages.isNotEmpty && _messages.last.chat_id == _msg.chat_id) {
        //await updateMessages(response);
      }
      await updateLastMessages(response);
    });
  }

  Future updateSentMessage(MessagesModel msg) {
    var _item = _messages
        .indexWhere((element) => element.message_uuid == msg.message_uuid);
    _messages[_item].receipt = msg.receipt;
    notifyListeners();
    return null;
  }

  Future updateMessages(MessagesModel msg) {
    _messages.add(msg);
    notifyListeners();
    return null;
  }

  Future updateLastMessages(MessagesModel msg) async {
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].chat_id == msg.chat_id) {
        _conversations[i].mostRecent = msg;
        _conversations[i].created_at = msg.created_at;
        notifyListeners();
        //send a reply back to the server that it has been delivered
        // await sendReadReceipt();
      }
    }
    return null;
  }

  Future sendReadReceipt() {
    return null;
  }

  UserModel _activeChatUser;
  UserModel get activeChatUser => _activeChatUser;
  Future<UserModel> getActiveChatUSer({int userId}) async {
    _activeChatUser = await _chatService.getUserByID(userId: userId);
    notifyListeners();
    return _activeChatUser;
  }
}
