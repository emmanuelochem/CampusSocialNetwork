// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';

enum LoadMoreFeedStatus { LOADING, STABLE }

class FeedState with ChangeNotifier {
  final FeedController _feedController = FeedController();

  /// POSTS FEED
  void resetPost() {
    _postsFetcher = PaginationModel();
  }

  PaginationModel _postsFetcher = PaginationModel();
  LoadMoreFeedStatus _postloadMoreStatus = LoadMoreFeedStatus.LOADING;
  getPostLoadMoreStatus() => _postloadMoreStatus;
  int posttotalPages = 0;
  bool _isPostFetched = false;
  List<dynamic> get allPosts => _postsFetcher.data;
  bool get posthasMore => _postsFetcher.hasMore;
  int get posttotalPage => posttotalPages;
  bool get isPostFetched => _isPostFetched;
  // bool _isPosting = false;
  // bool get isPosting => _isPosting;
  fetchPosts(pageNumber) async {
    if ((posttotalPages == 0) || pageNumber <= posttotalPages) {
      PaginationModel paginationModel =
          await _feedController.getTimeline(pageNumber: pageNumber);
      if (_postsFetcher.data.isEmpty) {
        posttotalPages = paginationModel.totalPages;
        _postsFetcher = paginationModel;
      } else {
        _postsFetcher.data.addAll(paginationModel.data);
        _postsFetcher = _postsFetcher;
        _postsFetcher.hasMore = paginationModel.hasMore;
        setPostLoadingState(LoadMoreFeedStatus.STABLE);
      }
      _isPostFetched = true;
      notifyListeners();
    }

    if (pageNumber > posttotalPages) {
      setPostLoadingState(LoadMoreFeedStatus.STABLE);
      notifyListeners();
    }
  }

  setPostLoadingState(LoadMoreFeedStatus loadMoreStatus) {
    _postloadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  Future togglePostLike({int postId}) async {
    notifyListeners();
    int kk = allPosts.indexWhere((element) => element['id'] == postId);
    if (allPosts[kk]['is_liked']) {
      if (allPosts[kk]['likes_count'] >= 0) {
        allPosts[kk]['is_liked'] = false;
        allPosts[kk]['likes_count']--;
      }
      notifyListeners();
      await _feedController.unlikePost(postId: allPosts[kk]['id']);
    } else {
      if (allPosts[kk]['likes_count'] >= 0) {
        allPosts[kk]['is_liked'] = true;
        allPosts[kk]['likes_count']++;
      }
      notifyListeners();
      await _feedController.likePost(postId: allPosts[kk]['id']);
    }
    //notifyListeners();
  }

  Future togglePostBookmark({int postId}) async {
    int p = allPosts.indexWhere((element) => element['id'] == postId);
    if (allPosts[p]['is_bookmarked']) {
      allPosts[p]['is_bookmarked'] = false;
      await _feedController.unBookmarkPost(postId: allPosts[p]['id']);
    } else {
      allPosts[p]['is_bookmarked'] = true;
      await _feedController.bookmarkPost(postId: allPosts[p]['id']);
    }
    notifyListeners();
  }

  int _actionedPostID = 0;
  int get actionedPostID => _actionedPostID;
  set actionedPostID(int postId) {
    _actionedPostID = postId;
    notifyListeners();
  }

  Future deletePost({int postId}) async {
    int p = allPosts.indexWhere((element) => element['id'] == postId);
    if (allPosts[p]['is_own_post']) {
      allPosts.removeWhere((element) => element['id'] == postId);
      notifyListeners();
      return 1;
      // var re = await _feedController.unBookmarkPost(postId: allPosts[p]['id']);
      // print(re);
    }
    // else not permitted
    notifyListeners();
  }
}
