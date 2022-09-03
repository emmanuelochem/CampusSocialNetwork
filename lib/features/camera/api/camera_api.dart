import 'package:mysocial_app/core/api/network_handler.dart';

class CameraApi extends BaseApi {
  Future createPost({Map<String, dynamic> data}) async {
    String route = 'posts/create';
    Map<String, dynamic> header = {};
    return await httpPost(
        route: route, data: data, header: header, hasToken: true);
  }
}
