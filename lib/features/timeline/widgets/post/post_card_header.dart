import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';
import 'package:mysocial_app/features/timeline/widgets/post/post_option_menu.dart';

class PostHeader extends StatelessWidget {
  final Map post;
  const PostHeader({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            //backgroundColor: Palette.facebookBlue,
            child: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  CachedNetworkImageProvider(post['user']['photo']),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['user']['nickname'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${post['timestamp']} • ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                      ),
                    ),
                    Icon(
                      Icons.public,
                      color: Colors.grey[600],
                      size: 12.0,
                    )
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                context.feedProvider.actionedPostID = post['id'];
                showMaterialModalBottomSheet(
                    context: context,
                    expand: false,
                    builder: (context) => PostActionMenu(
                          post: post,
                        ));
              }),
        ],
      ),
    );
  }
}
