import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysocial_app/features/explore/views/reel_page.dart';

class ExploreMediaTile extends StatelessWidget {
  const ExploreMediaTile({Key key, @required this.postData}) : super(key: key);
  final Map postData;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showMaterialModalBottomSheet(
        context: context,
        expand: false,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => Reels(
          postId: postData['id'],
        ),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          CachedNetworkImage(
            imageUrl: postData['image'],
            fadeInDuration: const Duration(milliseconds: 1000),
          ),
        ],
      ),
    );
  }
}
