import 'package:flutter/material.dart';
import 'post_card_body.dart';
import 'post_card_footer.dart';
import 'post_card_header.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key key,
    @required this.post,
    @required this.addComment,
  }) : super(key: key);

  final Map post;
  final Function(
    Map post, {
    String message,
  }) addComment;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 0.0,
      ),
      elevation: 0.0,
      shape: null,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            PostHeader(
              post: post,
            ),
            PostCardBody(
              post: post,
            ),
            PostFooter(
              post: post,
              onAddComment: addComment,
            ),
          ],
        ),
      ),
    );
  }
}
