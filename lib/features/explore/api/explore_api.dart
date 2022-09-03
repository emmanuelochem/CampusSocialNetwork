import 'package:mysocial_app/core/api/network_handler.dart';

class ExploreApi with BaseApi {
  Future getEplore({int pageNumber}) async {
    String route = 'posts/explore';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: true);
  }

  Future searchUser({String query}) async {
    String route = 'users/search?query=$query';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: true);
  }

  Future getReel({int postId}) async {
    String route = 'posts/explore/$postId';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: true);
  }

  Future likePost({int postID}) async {
    String route = 'posts/$postID/like';
    Map<String, dynamic> header = {};
    return await httpPost(route: route, header: header, hasToken: true);
  }

  Future unlikePost({int postID}) async {
    String route = 'posts/$postID/dislike';
    Map<String, dynamic> header = {};
    return await httpDelete(route: route, header: header, hasToken: true);
  }

  Future bookmarkPost({int postID}) async {
    String route = 'posts/$postID/bookmark';
    Map<String, dynamic> header = {};
    return await httpPost(route: route, header: header, hasToken: true);
  }

  Future unBookmarkPost({int postID}) async {
    String route = 'posts/$postID/unbookmark';
    Map<String, dynamic> header = {};
    return await httpDelete(route: route, header: header, hasToken: true);
  }
}
