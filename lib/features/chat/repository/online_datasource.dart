import 'package:mysocial_app/core/api/network_handler.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';

class OnlineDatasource extends BaseApi {
  Future<UserModel> fetchChatUserOnline({int userId}) async {
    // return null;
    String route = 'chats/user/find';
    Map<String, dynamic> header = {};
    Map<String, dynamic> data = {'id': userId};
    var users = await httpPost(
        route: route, data: data, header: header, hasToken: true);
    var userList = await users['data'];
    return UserModel.fromOnlineMap(userList[0]);
  }
  // Future<List<UserModel>> fetchChatUserOnline(List<int> ids) async {
  //   String route = 'chats/find';
  //   Map<String, dynamic> header = {};
  //   Map<String, dynamic> data = {'ids[]': ids};
  //   var users = await httpPost(
  //       route: route, data: data, header: header, hasToken: true);
  //   List userList = await users['data'];
  //   return userList.map((e) => UserModel.fromMap(e)).toList();
  // }

  Future<List<ChatModel>> findOnlineChats() async {
    String route = 'chats';
    Map<String, dynamic> header = {};
    var resp = await httpGet(route: route, header: header, hasToken: true);
    List<ChatModel> chatsList = [];
    await resp['data'].forEach((element) {
      chatsList.add(ChatModel.fromOnlineMap(element));
    });
    //log(chatsList.toString());
    return chatsList;
  }

  Future<List<ChatModel>> getOnlineNewChats() async {
    String route = 'chats/new';
    Map<String, dynamic> header = {};
    var resp = await httpGet(route: route, header: header, hasToken: true);
    List<ChatModel> chatsList = [];
    await resp['data'].forEach((element) {
      chatsList.add(ChatModel.fromOnlineMap(element));
    });
    //print(chatsList);
    return chatsList;
  }

  Future<MessagesModel> dispatchMessage(Map<String, dynamic> message) async {
    String route = 'chats/${message['chat_id']}/send';
    Map<String, dynamic> header = {};
    Map msg = await httpPost(
        route: route, data: message, header: header, hasToken: true);
    return MessagesModel.fromMap(msg['data']);
  }

  // Future<void> addChat(ChatModel conversation) async {}

  // Future<ChatModel> findChat(int chatId) async {}

  //

  // Future<List<MessagesModel>> findMessages(int chatId) async {}

  // Future<void> updateMessage(MessagesModel message) async {}

  // Future<void> deleteChat(String chatId) async {}

  // Future<void> updateMessageReceipt(String messageId) {}
}
