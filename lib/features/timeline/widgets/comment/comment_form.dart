import 'package:flutter/material.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';

class FloatingCommentBox extends StatefulWidget {
  FloatingCommentBox({
    Key key,
    @required this.post,
  }) : super(key: key);

  Map post;

  @override
  __CommentBoxState createState() => __CommentBoxState();
}

class __CommentBoxState extends State<FloatingCommentBox> {
  final TextEditingController _commentTextController = TextEditingController();
  FocusNode focusNode = FocusNode();

  Future<void> handleSubmit(String value) async {
    if (value != null && value.isNotEmpty) {
      _commentTextController.clear();
      FocusScope.of(context).unfocus();
      Map<String, dynamic> comment = {
        'body': value,
      };
      await context.commentsProvider
          .appendNewComment(comment: comment, postId: widget.post['id']);
    }
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: (Theme.of(context).brightness == Brightness.light)
            ? Colors.grey
            : Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommentBox(
              textEditingController: _commentTextController,
              onSubmitted: handleSubmit,
              focusNode: focusNode,
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}
