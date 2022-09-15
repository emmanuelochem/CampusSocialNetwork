import 'package:mysocial_app/core/api/network_handler.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';

// abstract class ODatasource {
// Future<List<ChatModel>> findOnlineChats();
// Future<void> addChat(ChatModel chat);
// Future<void> addMessage(MessagesModel message);
// Future<ChatModel> findChat(String chatId);
// Future<void> updateMessage(MessagesModel message);
// Future<List<MessagesModel>> findMessages(String chatId);
// Future<void> deleteChat(String chatId);
// Future<void> updateMessageReceipt(String messageId);
// }

class OnlineDatasource extends BaseApi {
  // @override
  Future<List<ChatModel>> findOnlineChats() async {
    String route = 'conversations';
    Map<String, dynamic> header = {};
    var resp = await httpGet(route: route, header: header, hasToken: true);
    List<ChatModel> td = [];
    await resp['data'].forEach((element) async {
      td.add(ChatModel.fromMap(element));
    });
    //print(td);
    return td;
  }

  // @override
  Future<void> addChat(ChatModel conversation) async {}

  // @override
  Future<ChatModel> findChat(String chatId) async {}

  // @override
  Future<void> addMessage(MessagesModel message) async {}

  // @override
  Future<List<MessagesModel>> findMessages(int chatId) async {}

  // @override
  Future<void> updateMessage(MessagesModel message) async {}

  // @override
  Future<void> deleteChat(String chatId) async {}

  // @override
  Future<void> updateMessageReceipt(String messageId) {}
}
