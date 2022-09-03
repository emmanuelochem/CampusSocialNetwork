import 'package:mysocial_app/core/api/network_handler.dart';

class ProfileApi extends BaseApi {
  Future getProfile({int profileId}) async {
    String route = 'profile/$profileId';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: true);
  }

  Future followUser({int userID}) async {
    String route = 'profile/$userID/follow';
    Map<String, dynamic> header = {};
    return await httpPost(route: route, header: header, hasToken: true);
  }

  Future unfollowUser({int userID}) async {
    String route = 'profile/$userID/unfollow';
    Map<String, dynamic> header = {};
    return await httpDelete(route: route, header: header, hasToken: true);
  }

  Future crushUser({int userID}) async {
    String route = 'profile/$userID/crush';
    Map<String, dynamic> header = {};
    return await httpPost(route: route, header: header, hasToken: true);
  }

  Future uncrushUser({int userID}) async {
    String route = 'profile/$userID/uncrush';
    Map<String, dynamic> header = {};
    return await httpDelete(route: route, header: header, hasToken: true);
  }
  //get, post, bookmarks, likes, comments likes, comments, crushes, followers, following,
}
