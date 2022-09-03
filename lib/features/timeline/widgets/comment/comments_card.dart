import 'package:flutter/material.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';

import 'package:provider/provider.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class CommentsCard extends StatelessWidget {
  Map comment;
  CommentsCard({Key key, @required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 13, right: 15, left: 15),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage("${comment['user']['photo']}"),
            radius: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${comment['user']['nickname']}',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '${comment['body']}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(
                    '${comment['timestamp']}',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  // const Text(
                  //   '•',
                  //   style: TextStyle(
                  //       color: Colors.grey,
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w500),
                  // ),
                  // const SizedBox(
                  //   width: 7,
                  // ),
                  Consumer<CommentsState>(builder: (context, state, child) {
                    var item = state.allComments.indexWhere(
                        (element) => element['id'] == comment['id']);
                    return state.allComments[item]['likes_count'] == 0
                        ? const SizedBox.shrink()
                        : Text(
                            "${state.allComments[item]['likes_count']} ${(state.allComments[item]['likes_count'] > 1) ? 'likes' : 'like'}",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          );
                  }),
                  const SizedBox(
                    width: 7,
                  ),
                  comment['is_own_comment']
                      ? Row(
                          children: [
                            // const Text(
                            //   '•',
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontSize: 13,
                            //       fontWeight: FontWeight.w500),
                            // ),
                            // const SizedBox(
                            //   width: 7,
                            // ),
                            Consumer<CommentsState>(
                                builder: (context, state, child) {
                              return GestureDetector(
                                onTap: () async {
                                  await state.deleteComment(
                                      postID: comment['post_id'],
                                      commentId: comment['id']);
                                },
                                child: Icon(
                                  PhosphorIcons.trash_simple,
                                  color: Colors.grey.shade500,
                                  size: 17,
                                ),
                              );
                            }),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ],
          )),
          const SizedBox(
            width: 10,
          ),
          Consumer<CommentsState>(builder: (context, state, child) {
            var item = state.allComments
                .indexWhere((element) => element['id'] == comment['id']);
            return GestureDetector(
              onTap: () async {
                await state.toggleLike(commentId: comment['id']);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    state.allComments[item]['is_liked']
                        ? PhosphorIcons.heart_fill
                        : PhosphorIcons.heart,
                    color: state.allComments[item]['is_liked']
                        ? Colors.red
                        : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
