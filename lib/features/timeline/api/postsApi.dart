import 'package:mysocial_app/core/api/network_handler.dart';

class PostsApi extends BaseApi {
  Future getPosts({int pagination}) async {
    String route = 'posts/feed?page=$pagination';
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

  Future getComments({int postID, int pagination}) async {
    String route = 'posts/$postID/comments?page=$pagination';
    Map<String, dynamic> header = {};
    return await httpGet(route: route, header: header, hasToken: true);
  }

  Future postComment({
    Map<String, dynamic> data,
    int postID,
  }) async {
    String route = 'posts/$postID/comments/create';
    Map<String, dynamic> header = {};
    return await httpPost(
        route: route, data: data, header: header, hasToken: true);
  }

  Future likeComments({int postID, int commentID}) async {
    String route = 'posts/$postID/comments/$commentID/like';
    Map<String, dynamic> header = {};
    return await httpPost(route: route, header: header, hasToken: true);
  }

  Future unlikeComments({int postID, int commentID}) async {
    String route = 'posts/$postID/comments/$commentID/unlike';
    Map<String, dynamic> header = {};
    return await httpDelete(route: route, header: header, hasToken: true);
  }

  Future updateComment({int postID, int commentID}) async {
    String route = 'posts/$postID/comments/$commentID/update';
    Map<String, dynamic> header = {};
    return await httpDelete(route: route, header: header, hasToken: true);
  }

  Future deleteComment({int postID, int commentID}) async {
    String route = 'posts/$postID/comments/$commentID/delete';
    Map<String, dynamic> header = {};
    return await httpDelete(route: route, header: header, hasToken: true);
  }
}
