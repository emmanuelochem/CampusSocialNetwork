import 'package:flutter/material.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';

enum LoadMoreStatus { LOADING, STABLE }

class CommentsState extends ChangeNotifier {
  final FeedController _feedController = FeedController();

//**
//COMMENTS
  PaginationModel _commentsFetcher = PaginationModel();
  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.LOADING;
  getLoadMoreStatus() => _loadMoreStatus;
  int totalPages = 0;
  bool _isFetched = false;
  List<dynamic> get allComments => _commentsFetcher.data;
  bool get hasMore => _commentsFetcher.hasMore;
  int get totalPage => totalPages;
  bool get isFetched => _isFetched;
  bool _isPosting = false;
  bool get isPosting => _isPosting;

  void resetStreams() {
    _isPosting = false;
    _isFetched = false;
    _commentsFetcher = PaginationModel();
  }

  fetchAllComments(postID, pageNumber) async {
    if ((totalPages == 0) || pageNumber <= totalPages) {
      PaginationModel paginationModel = await _feedController.getPostComments(
          postId: postID, pageNumber: pageNumber);
      if (_commentsFetcher.data.isEmpty) {
        totalPages = paginationModel.totalPages;
        _commentsFetcher = paginationModel;
      } else {
        _commentsFetcher.data.addAll(paginationModel.data);
        _commentsFetcher = _commentsFetcher;
        _commentsFetcher.hasMore = paginationModel.hasMore;
        setLoadingState(LoadMoreStatus.STABLE);
      }
      _isFetched = true;
      notifyListeners();
    }

    if (pageNumber > totalPages) {
      setLoadingState(LoadMoreStatus.STABLE);
      notifyListeners();
    }
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  Future appendNewComment(
      {String to, Map<String, dynamic> comment, int postId}) async {
    _isPosting = true;
    notifyListeners();
    var res =
        await _feedController.addComments(comment: comment, postId: postId);
    if (res != null) {
      allComments.insert(0, res);
      _isPosting = false;
      notifyListeners();
    }
  }

  Future deleteComment({int postID, int commentId}) async {
    _isPosting = true;
    notifyListeners();
    Map res = await _feedController.deleteComment(
        postId: postID, commentId: commentId);
    if (res['status'] == 'success') {
      allComments.removeWhere((element) => element['id'] == commentId);
      _isPosting = false;
      notifyListeners();
    }
  }

  Future toggleLike({int commentId}) async {
    _isPosting = true;
    notifyListeners();
    int index = allComments.indexWhere((element) => element['id'] == commentId);
    if (allComments[index]['is_liked']) {
      if (allComments[index]['likes_count'] >= 0) {
        allComments[index]['is_liked'] = false;
        allComments[index]['likes_count']--;
      }
      _isPosting = false;
      notifyListeners();
      await _feedController.unlikeComments(
          postId: allComments[index]['post_id'], commentId: commentId);
    } else {
      if (allComments[index]['likes_count'] >= 0) {
        allComments[index]['is_liked'] = true;
        allComments[index]['likes_count']++;
      }
      _isPosting = false;
      notifyListeners();
      await _feedController.likeComments(
          postId: allComments[index]['post_id'], commentId: commentId);
    }
    _isPosting = false;
    notifyListeners();
  }
}
