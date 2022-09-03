import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class PostCardBody extends StatelessWidget {
  final Map post;
  const PostCardBody({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        post['caption'] == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ExpandableText(
                  '${post['caption']}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                  expandOnTextTap: true,
                  collapseOnTextTap: true,
                  expandText: 'more',
                  collapseText: 'less',
                  maxLines: 1,
                  linkColor: Colors.grey,
                ),
              ),
        post['image'] == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: CachedNetworkImage(imageUrl: post['image']),
              ),
      ],
    );
  }
}
