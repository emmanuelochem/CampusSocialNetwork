import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/features/explore/providers/explore_provider.dart';
import 'package:mysocial_app/features/explore/widgets/reel/reel_body.dart';
import 'package:provider/provider.dart';

class Reels extends StatelessWidget {
  Reels({Key key, @required this.postId}) : super(key: key);
  final int postId;

  ExploreProvider _exploreProvider;

  @override
  Widget build(BuildContext context) {
    _exploreProvider = context.read<ExploreProvider>();
    _exploreProvider.resetReels();
    _exploreProvider.fetchReels(postId: postId);
    return Consumer<ExploreProvider>(
      builder: (context, exploreProvider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: Text('Watch',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(PhosphorIcons.dots_three_bold),
                color: Colors.white,
              )
            ],
          ),
          body: (exploreProvider.reelList.isNotEmpty &&
                  !exploreProvider.isReelFetching)
              ? Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: exploreProvider.reelList.length,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (id) {
                          //set as viewed
                        },
                        itemBuilder: (context, index) {
                          final Map reelItem = exploreProvider.reelList[index];
                          return ReelContentBody(post: reelItem);
                        },
                      ),
                    ),

                    //Add comment bar
                  ],
                )
              : (exploreProvider.reelList.isEmpty &&
                      exploreProvider.isPostFetched)
                  ? const Text('no posts')
                  : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
