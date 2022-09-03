import 'package:mysocial_app/features/timeline/timeline.dart';

class FeedController {
  final PostsApi _postsApi = PostsApi();

  Future<PaginationModel> getTimeline({int pageNumber}) async {
    var response = await _postsApi.getPosts(pagination: pageNumber);
    if (response != null) {
      return PaginationModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<Map> likePost({int postId}) async {
    Map like = await _postsApi.likePost(
      postID: postId,
    );
    return like;
  }

  Future<Map> unlikePost({int postId}) async {
    Map unlike = await _postsApi.unlikePost(
      postID: postId,
    );
    return unlike;
  }

  Future<PaginationModel> getPostComments({int postId, int pageNumber}) async {
    var response =
        await _postsApi.getComments(postID: postId, pagination: pageNumber);
    if (response != null) {
      return PaginationModel.fromJson(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<Map> likeComments({int postId, int commentId}) async {
    Map like = await _postsApi.likeComments(
      postID: postId,
      commentID: commentId,
    );
    return like;
  }

  Future<Map> unlikeComments({int postId, int commentId}) async {
    Map unlike = await _postsApi.unlikeComments(
      postID: postId,
      commentID: commentId,
    );
    return unlike;
  }

  Future<Map> addComments({
    Map<String, dynamic> comment,
    int postId,
  }) async {
    Map response = await _postsApi.postComment(data: comment, postID: postId);
    return response['data'];
  }

  Future deleteComment({int postId, int commentId}) async {
    Map comment = await _postsApi.deleteComment(
      postID: postId,
      commentID: commentId,
    );
    return comment;
  }

  Future<Map> bookmarkPost({int postId}) async {
    Map bookmark = await _postsApi.bookmarkPost(postID: postId);
    return bookmark;
  }

  Future<Map> unBookmarkPost({int postId}) async {
    Map bookmark = await _postsApi.unBookmarkPost(postID: postId);
    return bookmark;
  }
}
