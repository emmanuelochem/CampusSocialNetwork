import 'package:flutter/material.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TrackingScrollController _scrollController = TrackingScrollController();
  int _page = 1;
  @override
  void initState() {
    super.initState();
    context.feedProvider.resetPost();
    context.feedProvider.fetchPosts(_page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.feedProvider.setPostLoadingState(LoadMoreFeedStatus.LOADING);
        context.feedProvider.fetchPosts(++_page);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final ValueNotifier<bool> _showCommentBox = ValueNotifier(false);
  final TextEditingController _commentTextController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  Map postData = {};

  void openCommentBox(Map post, {String message}) {
    _commentTextController.text = message ?? '';
    _commentTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentTextController.text.length));
    postData = post;
    _showCommentBox.value = true;
    _commentFocusNode.requestFocus();
  }

  Future<void> addComment(String message) async {
    if (postData != null &&
        message != null &&
        message.isNotEmpty &&
        message != '') {
      Map<String, dynamic> comment = {
        'body': _commentTextController.text,
      };
      await context.commentsProvider
          .appendNewComment(comment: comment, postId: postData['id']);
      _commentTextController.clear();
      FocusScope.of(context).unfocus();
      _showCommentBox.value = false;
    }
  }

  // @override
  // void dispose() {
  //   _commentTextController.dispose();
  //   _commentFocusNode.dispose();
  //   super.dispose();
  // }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF0F2F5),
      body: Consumer<FeedState>(builder: (context, state, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _showCommentBox.value = false;
          },
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  //Header
                  const FeedHeader(),

                  // // StoryBlock
                  // SliverToBoxAdapter(
                  //     child: Column(
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.only(top: 0),
                  //       color: Colors.white,
                  //       height: 108,
                  //       child: ListView.builder(
                  //           scrollDirection: Axis.horizontal,
                  //           itemCount: 1 + stories.length,
                  //           itemBuilder: ((context, index) {
                  //             return Container(
                  //               color: Colors.white,
                  //               width: 80,
                  //               padding: const EdgeInsets.symmetric(vertical: 5),
                  //               child: index == 0
                  //                   ? const AddStoryCard()
                  //                   : StoryCard(
                  //                       story: stories[index - 1],
                  //                     ),
                  //             );
                  //           })),
                  //     ),
                  //   ],
                  // )),

                  (state.allPosts.isNotEmpty && state.isPostFetched)
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              int lastItem = state.allPosts.length - 1;
                              final post = state.allPosts[index];
                              return Column(
                                children: [
                                  PostCard(
                                    //key: ValueKey('post-${post['id']}'),
                                    post: post,
                                    addComment: openCommentBox,
                                  ),
                                  ((index == lastItem) && state.posthasMore)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ],
                                        )
                                      : ((index == lastItem) &&
                                              state.posthasMore == false)
                                          ? const Text('~The End~')
                                          : const SizedBox.shrink()
                                ],
                              );
                            },
                            childCount: state.allPosts.length,
                          ),
                        )
                      : (state.allPosts.isEmpty && state.isPostFetched)
                          ? const SliverToBoxAdapter(child: Text('no posts'))
                          : const SliverToBoxAdapter(
                              child:
                                  Center(child: CircularProgressIndicator())),
                ],
              ),
              _CommentBox(
                textEditingController: _commentTextController,
                focusNode: _commentFocusNode,
                addComment: addComment,
                showCommentBox: _showCommentBox,
              )
            ],
          ),
        );
      }),
    );
  }
}

class _CommentBox extends StatefulWidget {
  const _CommentBox({
    Key key,
    @required this.textEditingController,
    @required this.focusNode,
    @required this.addComment,
    @required this.showCommentBox,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String) addComment;
  final ValueNotifier<bool> showCommentBox;

  @override
  __CommentBoxState createState() => __CommentBoxState();
}

class __CommentBoxState extends State<_CommentBox>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          visibility = false;
        });
      } else {
        setState(() {
          visibility = true;
        });
      }
    });
    widget.showCommentBox.addListener(_showHideCommentBox);
  }

  void _showHideCommentBox() {
    if (widget.showCommentBox.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: FadeTransition(
        opacity: _animation,
        child: Builder(builder: (context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: CommentBox(
              textEditingController: widget.textEditingController,
              focusNode: widget.focusNode,
              onSubmitted: widget.addComment,
            ),
          );
        }),
      ),
    );
  }
}
