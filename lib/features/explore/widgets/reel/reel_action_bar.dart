import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysocial_app/features/explore/providers/explore_provider.dart';
import 'package:mysocial_app/features/explore/widgets/reel/reel_comment.dart';
import 'package:provider/provider.dart';

class ReelActionBar extends StatelessWidget {
  ReelActionBar({Key key, @required this.post}) : super(key: key);
  final Map post;

  double _iconSize = 20;

  @override
  Widget build(BuildContext context) {
    _iconSize = 35;
    return Consumer<ExploreProvider>(builder: (context, state, child) {
      var item =
          state.reelList.indexWhere((element) => element['id'] == post['id']);
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //ReelProfileImage(image: state.reelList[item]['image']),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async =>
                await state.togglePostLike(postId: post['id']),
            icon: state.reelList[item]['is_liked']
                ? SvgPicture.asset(
                    "assets/images/icons/loved_icon.svg",
                    width: _iconSize,
                  )
                : SvgPicture.asset(
                    "assets/images/icons/love_icon.svg",
                    width: _iconSize,
                  ),
            iconSize: _iconSize,
            color: Colors.white,
          ),
          Text(
            '${state.reelList[item]['likes_count']}',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => showMaterialModalBottomSheet(
                context: context,
                expand: false,
                builder: (context) => ReelComments(
                      post: post,
                    )),
            icon: const Icon(PhosphorIcons.chat_circle_dots),
            iconSize: _iconSize,
            color: Colors.white,
          ),
          Text(
            '${state.reelList[item]['comments_count']}',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async =>
                await state.togglePostBookmark(postId: post['id']),
            icon: state.reelList[item]['is_bookmarked']
                ? const Icon(PhosphorIcons.bookmark_simple_fill)
                : const Icon(PhosphorIcons.bookmark_simple),
            iconSize: _iconSize,
            color: Colors.white,
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => showMaterialModalBottomSheet(
              context: context,
              expand: false,
              builder: (context) => ReelComments(
                post: post,
              ),
            ),
            icon: const Icon(
              PhosphorIcons.dots_three_vertical,
            ),
            iconSize: _iconSize,
            color: Colors.white,
          ),
        ],
      );
    });
  }
}
