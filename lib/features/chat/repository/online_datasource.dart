import 'package:mysocial_app/core/api/network_handler.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';

class OnlineDatasource extends BaseApi {
  Future<List<LocalUser>> fetchChatUser(List<int> ids) async {
    String route = 'chats/find';
    Map<String, dynamic> header = {};
    Map<String, dynamic> data = {'ids[]': ids};
    var users = await httpPost(
        route: route, data: data, header: header, hasToken: true);
    List userList = await users['data'];
    return userList.map((e) => LocalUser.fromMap(e)).toList();
  }

  Future<List<ChatModel>> findOnlineChats() async {
    String route = 'chats';
    Map<String, dynamic> header = {};
    var resp = await httpGet(route: route, header: header, hasToken: true);
    List<ChatModel> chatsList = [];
    await resp['data'].forEach((element) {
      chatsList.add(ChatModel.fromMap(element));
    });
    //print(chatsList);
    return chatsList;
  }

  Future<List<ChatModel>> getOnlineNewChats() async {
    String route = 'chats/new';
    Map<String, dynamic> header = {};
    var resp = await httpGet(route: route, header: header, hasToken: true);
    List<ChatModel> chatsList = [];
    await resp['data'].forEach((element) {
      chatsList.add(ChatModel.fromMap(element));
    });
    //print(chatsList);
    return chatsList;
  }

  Future<MessagesModel> dispatchMessage(Map<String, dynamic> message) async {
    String route = 'chats/${message['chat_id']}/send';
    Map<String, dynamic> header = {};
    Map msg = await httpPost(
        route: route, data: message, header: header, hasToken: true);
    //log(msg.toString());
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
