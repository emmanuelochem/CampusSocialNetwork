import 'package:flutter/material.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';
import 'package:mysocial_app/features/timeline/widgets/comment/comment_form.dart';

import 'package:provider/provider.dart';

class PostComments extends StatefulWidget {
  final Map post;

  const PostComments({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Comments',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<CommentsState>(builder: (context, state, child) {
        if (_scrollController.hasClients && state.isPosting) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 200),
          );
        }
        return Column(
          children: [
            (state.isPosting)
                ? const LinearProgressIndicator()
                : const SizedBox.shrink(),
            Expanded(
              child: (state.allComments.isNotEmpty && state.isFetched)
                  ? ListView.separated(
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
            FloatingCommentBox(post: widget.post),
          ],
        );
      }),
    );
  }
}
