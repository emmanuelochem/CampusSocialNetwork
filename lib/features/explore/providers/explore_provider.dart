import 'package:flutter/material.dart';
import 'package:mysocial_app/features/explore/controllers/explore_controller.dart';
import 'package:mysocial_app/features/timeline/models/paginationModel.dart';

enum LoadMoreFeedStatus { LOADING, STABLE }

class ExploreProvider extends ChangeNotifier {
  final ExploreController _exploreController = ExploreController();

  Future searchUsers({String query}) async {
    setSearchState(true);
    var res = await _exploreController.searchUser(query: query);
    setSearchResult(res['data']);
    setSearchState(false);
    notifyListeners();
  }

  List _searchResult;
  List get searchResult => _searchResult;
  setSearchResult(List value) {
    _searchResult = value;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  setSearchState(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  bool _isSearchActive = false;
  bool get isSearchActive => _isSearchActive;
  setSearchActive(bool value) {
    _isSearchActive = value;
    notifyListeners();
  }

  ///

  /// POSTS FEED
  void resetPost() {
    _postsFetcher = PaginationModel();
  }

  PaginationModel _postsFetcher = PaginationModel();
  LoadMoreFeedStatus _postloadMoreStatus = LoadMoreFeedStatus.LOADING;
  getPostLoadMoreStatus() => _postloadMoreStatus;
  int posttotalPages = 0;
  bool _isPostFetched = false;
  List<dynamic> get explorePosts => _postsFetcher.data;
  bool get exploreHasMore => _postsFetcher.hasMore;
  int get posttotalPage => posttotalPages;
  bool get isPostFetched => _isPostFetched;
  // bool _isPosting = false;
  // bool get isPosting => _isPosting;
  fetchExplorePosts({int pageNumber}) async {
    if ((posttotalPages == 0) || pageNumber <= posttotalPages) {
      PaginationModel paginationModel =
          await _exploreController.getEplore(pageNumber: pageNumber);
      if (_postsFetcher.data.isEmpty) {
        posttotalPages = paginationModel.totalPages;
        _postsFetcher = paginationModel;
      } else {
        _postsFetcher.data.addAll(paginationModel.data);
        _postsFetcher = _postsFetcher;
        _postsFetcher.hasMore = paginationModel.hasMore;
        setExplorePostLoadingState(LoadMoreFeedStatus.STABLE);
      }
      _isPostFetched = true;
      notifyListeners();
    }

    if (pageNumber > posttotalPages) {
      setExplorePostLoadingState(LoadMoreFeedStatus.STABLE);
      notifyListeners();
    }
  }

  setExplorePostLoadingState(LoadMoreFeedStatus loadMoreStatus) {
    _postloadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

//REELS
  List<dynamic> _reelList = [];
  List<dynamic> get reelList => _reelList;
  fetchReels({postId}) async {
    setReelFetchingState(true);
    _reelList = await _exploreController.getReel(postId: postId);
    setReelFetchingState(false);
    notifyListeners();
  }

  bool _isReelFetching = false;
  bool get isReelFetching => _isReelFetching;
  setReelFetchingState(bool value) {
    _isReelFetching = value;
    //notifyListeners();
  }

  void resetReels() {
    _reelList = [];
  }

  Future togglePostLike({int postId}) async {
    notifyListeners();
    int kk = _reelList.indexWhere((element) => element['id'] == postId);
    if (_reelList[kk]['is_liked']) {
      if (_reelList[kk]['likes_count'] >= 0) {
        _reelList[kk]['is_liked'] = false;
        _reelList[kk]['likes_count']--;
      }
      notifyListeners();
      await _exploreController.unlikePost(postId: _reelList[kk]['id']);
    } else {
      if (_reelList[kk]['likes_count'] >= 0) {
        _reelList[kk]['is_liked'] = true;
        _reelList[kk]['likes_count']++;
      }
      notifyListeners();
      await _exploreController.likePost(postId: _reelList[kk]['id']);
    }
    //notifyListeners();
  }

  Future togglePostBookmark({int postId}) async {
    int p = _reelList.indexWhere((element) => element['id'] == postId);
    if (_reelList[p]['is_bookmarked']) {
      _reelList[p]['is_bookmarked'] = false;
      await _exploreController.unBookmarkPost(postId: _reelList[p]['id']);
    } else {
      _reelList[p]['is_bookmarked'] = true;
      await _exploreController.bookmarkPost(postId: _reelList[p]['id']);
    }
    notifyListeners();
  }
}
