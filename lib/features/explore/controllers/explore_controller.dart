import 'package:mysocial_app/features/explore/api/explore_api.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';

class ExploreController {
  final ExploreApi _exploreApi = ExploreApi();

  Future<PaginationModel> getEplore({int pageNumber}) async {
    var response = await _exploreApi.getEplore(pageNumber: pageNumber);
    if (response != null) {
      return PaginationModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future searchUser({String query}) async {
    var response = await _exploreApi.searchUser(query: query);
    if (response != null) {
      return response;
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future getReel({int postId}) async {
    var response = await _exploreApi.getReel(postId: postId);
    //print(response);
    if (response != null) {
      return response['data'];
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<Map> likePost({int postId}) async {
    Map like = await _exploreApi.likePost(
      postID: postId,
    );
    return like;
  }

  Future<Map> unlikePost({int postId}) async {
    Map unlike = await _exploreApi.unlikePost(
      postID: postId,
    );
    return unlike;
  }

  Future<Map> bookmarkPost({int postId}) async {
    Map bookmark = await _exploreApi.bookmarkPost(postID: postId);
    return bookmark;
  }

  Future<Map> unBookmarkPost({int postId}) async {
    Map bookmark = await _exploreApi.unBookmarkPost(postID: postId);
    return bookmark;
  }
}
