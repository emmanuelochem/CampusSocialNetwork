import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysocial_app/features/timeline/providers/feeds_provider.dart';
import 'package:mysocial_app/features/timeline/views/comments_page.dart';
import 'package:provider/provider.dart';

// typedef OnAddComment = void Function(
//   Map activity, {
//   String message,
// });

class PostFooter extends StatelessWidget {
  final Map post;
  final Function(
    Map post, {
    String message,
  }) onAddComment;

  const PostFooter({
    Key key,
    @required this.post,
    @required this.onAddComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedState>(builder: (context, state, child) {
      var item =
          state.allPosts.indexWhere((element) => element['id'] == post['id']);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${state.allPosts[item]['likes_count']} ${(state.allPosts[item]['likes_count'] > 1) ? 'likes' : 'like'} ",
                    style: TextStyle(
                      color: Colors.grey[600],
                    )),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostComments(
                                post: post,
                              ))),
                  child:
                      Text("${state.allPosts[item]['comments_count']} Comments",
                          style: TextStyle(
                            color: Colors.grey[600],
                          )),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async => {
                    await state.togglePostLike(postId: post['id']),
                  },
                  child: post['is_liked']
                      ? SvgPicture.asset(
                          "assets/images/icons/loved_icon.svg",
                          width: 27,
                        )
                      : SvgPicture.asset(
                          "assets/images/icons/love_icon.svg",
                          width: 27,
                          color: Colors.black,
                        ),
                  //iconSize: _iconSize,
                ),
                const SizedBox(
                  width: 15,
                ),
                // GestureDetector(
                //   onTap: () => {},
                //   child: SvgPicture.asset(
                //     "assets/images/icons/message_icon.svg",
                //     width: 27,
                //     color: Colors.black,
                //   ),
                //   //iconSize: _iconSize,
                // ),
                Expanded(
                  child: _CommentSlab(
                    activity: post,
                    onAddComment: onAddComment,
                  ),
                ),
                //const Spacer(),
                // GestureDetector(
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => PostComments(
                //                 enrichedActivity: post,
                //                 activityOwnerData: const {},
                //               ))),
                //   child: SvgPicture.asset(
                //     "assets/images/icons/comment_icon.svg",
                //     width: 27,
                //     color: Colors.black,
                //   ),
                //   //iconSize: _iconSize,
                // ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _CommentSlab extends StatefulWidget {
  const _CommentSlab({
    Key key,
    @required this.activity,
    @required this.onAddComment,
  }) : super(key: key);

  final Map activity;
  final Function onAddComment;

  @override
  _CommentSlabState createState() => _CommentSlabState();
}

class _CommentSlabState extends State<_CommentSlab> {
  Map get postActivity => widget.activity;

  // List<Map> get _commentReactions => [];

  //int get _commentCount => 0;

  @override
  Widget build(BuildContext context) {
    const textPadding = EdgeInsets.all(8);
    // const spacePadding = EdgeInsets.only(left: 20.0, top: 8);
    // final comments = _commentReactions;
    // final commentCount = _commentCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.onAddComment(postActivity);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 1.0, top: 0, right: 0),
            child: Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Add a comment',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onAddComment(postActivity, message: '❤️');
                  },
                  child: const Padding(
                    padding: textPadding,
                    child: Text('❤️'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onAddComment(postActivity, message: '🙌');
                  },
                  child: const Padding(
                    padding: textPadding,
                    child: Text('🙌'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
