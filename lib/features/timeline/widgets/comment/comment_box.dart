import 'package:flutter/material.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';
import 'package:provider/provider.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({
    Key key,
    @required this.textEditingController,
    @required this.focusNode,
    @required this.onSubmitted,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String) onSubmitted;

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    final border = _border(context);
    return Consumer<CommentsState>(builder: (context, state, child) {
      return Container(
        padding:
            const EdgeInsets.only(bottom: 20, top: 10, right: 13, left: 13),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey.shade300),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _emojiText('❤️'),
                  _emojiText('🙌'),
                  _emojiText('🔥'),
                  _emojiText('👏🏻'),
                  _emojiText('😢'),
                  _emojiText('😍'),
                  _emojiText('😮'),
                  _emojiText('😂'),
                ],
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://csn-test-bucket.s3.amazonaws.com/images/Lrm19kqvfDYhc1gbbldVf63eBVETSIWjrKrAAZvR.jpg"),
                    radius: 20,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.textEditingController,
                    focusNode: widget.focusNode,
                    onSubmitted: widget.onSubmitted,
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        suffix: _DoneButton(
                          textEditorFocusNode: widget.focusNode,
                          textEditingController: widget.textEditingController,
                          onSubmitted: widget.onSubmitted,
                        ),
                        hintText: 'Add a comment...',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        focusedBorder: border,
                        border: border,
                        enabledBorder: border),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  OutlineInputBorder _border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      borderSide: BorderSide(
        color: (Theme.of(context).brightness == Brightness.light)
            ? Colors.grey.withOpacity(0.3)
            : Colors.white.withOpacity(0.5),
        width: 0.5,
      ),
    );
  }

  Widget _emojiText(String emoji) {
    return GestureDetector(
      onTap: () {
        widget.focusNode.requestFocus();
        widget.textEditingController.text =
            widget.textEditingController.text + emoji;
        widget.textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.textEditingController.text.length));
      },
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

class _DoneButton extends StatefulWidget {
  const _DoneButton({
    Key key,
    @required this.onSubmitted,
    @required this.textEditorFocusNode,
    @required this.textEditingController,
  }) : super(key: key);

  final Function(String) onSubmitted;
  final FocusNode textEditorFocusNode;
  final TextEditingController textEditingController;

  @override
  State<_DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends State<_DoneButton> {
  TextStyle textStyle =
      const TextStyle(fontWeight: FontWeight.w700, color: Colors.grey);
  TextStyle fadedTextStyle =
      const TextStyle(fontWeight: FontWeight.w700, color: Colors.grey);

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      if (widget.textEditingController.text.isNotEmpty) {
        textStyle = const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF0095F6),
        );
      } else {
        textStyle = fadedTextStyle;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.textEditorFocusNode.hasFocus
        ? GestureDetector(
            onTap: () {
              widget.onSubmitted(widget.textEditingController.text);
            },
            child: Text(
              'Done',
              style: textStyle,
            ),
          )
        : const SizedBox.shrink();
  }
}
