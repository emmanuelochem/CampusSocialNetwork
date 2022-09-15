import 'package:mysocial_app/core/api/network_handler.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';

abstract class IUserService {
  Future<LocalUser> connect(LocalUser user);
  Future<List<LocalUser>> online();
  Future<void> disconnect(LocalUser user);
  Future<List<LocalUser>> fetch(List<int> id);
}

class UserService extends BaseApi implements IUserService {
  @override
  Future<LocalUser> connect(LocalUser user) async {}

  @override
  Future<void> disconnect(LocalUser user) async {}

  @override
  Future<List<LocalUser>> online() async {}

  @override
  Future<List<LocalUser>> fetch(List<int> ids) async {
    String route = 'conversations/find';
    Map<String, dynamic> header = {};
    Map<String, dynamic> data = {'ids[]': ids};
    var users = await httpPost(
        route: route, data: data, header: header, hasToken: true);
    List userList = await users['data'];
    return userList.map((e) => LocalUser.fromMap(e)).toList();
  }
}
