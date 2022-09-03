import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/core/extensions/extension.dart';
import 'package:mysocial_app/features/timeline/providers/comments_provider.dart';
import 'package:mysocial_app/features/timeline/widgets/comment/comment_form.dart';
import 'package:provider/provider.dart';

import '../../../timeline/widgets/comment/comments_card.dart';
import '../../../timeline/widgets/comment/no_comment.dart';

class ReelComments extends StatefulWidget {
  const ReelComments({Key key, @required this.post}) : super(key: key);
  final Map post;
  @override
  State<ReelComments> createState() => _ReelCommentsState();
}

class _ReelCommentsState extends State<ReelComments> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    super.initState();

    context.commentsProvider.resetStreams();
    context.commentsProvider.fetchAllComments(widget.post['id'], _page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.commentsProvider.setLoadingState(LoadMoreStatus.LOADING);
        context.commentsProvider.fetchAllComments(widget.post['id'], ++_page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 0.75.sh,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Consumer<CommentsState>(builder: (context, state, child) {
        if (_scrollController.hasClients && state.isPosting) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 200),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => null,
                    icon: const Icon(
                      PhosphorIcons.x_bold,
                    ),
                    iconSize: 23,
                    color: Colors.white,
                  ),
                  Text(
                    '${widget.post['comments_count'] > 0 ? widget.post['comments_count'] : ''} ${widget.post['comments_count'] > 1 ? 'Comments' : 'Comment'}',
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      PhosphorIcons.x_bold,
                    ),
                    iconSize: 23,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Expanded(
              child: (state.allComments.isNotEmpty && state.isFetched)
                  ? ListView.separated(
                      padding: EdgeInsets.zero,
                      controller: _scrollController,
                      itemCount: state.allComments.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        int lastItem = state.allComments.length - 1;
                        return Column(
                          children: [
                            CommentsCard(comment: state.allComments[index]),
                            ((index == lastItem) && state.hasMore)
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ((index == lastItem) &&
                                        state.hasMore == false)
                                    ? const Text('.')
                                    : const SizedBox()
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox();
                      },
                    )
                  : (state.allComments.isEmpty && state.isFetched)
                      ? const NoComments()
                      : const Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: FloatingCommentBox(post: widget.post),
            ),
          ],
        );
      }),
    );
  }
}
