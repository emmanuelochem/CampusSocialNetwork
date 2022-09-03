import 'package:mysocial_app/core/api/network_handler.dart';

class UserApi extends BaseApi {
  Future ping({Map<String, dynamic> data}) async {
    String route = 'users/ping';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: true);
  }
}
