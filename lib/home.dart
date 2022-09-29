import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysocial_app/features/camera/views/gallery_screen.dart';
import 'package:mysocial_app/features/chat/views/chats.dart';
import 'package:mysocial_app/features/explore/views/explore_page.dart';
import 'package:mysocial_app/features/profile/views/profile_page.dart';
import 'package:mysocial_app/features/timeline/views/feeds_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key key}) : super(key: key);

  static final List<Widget> _homePages = <Widget>[
    FeedPage(),
    const ExplorePage(),
    //CameraScreen(),
    GalleryScreen(),
    ChatPage(),
    ProfilePage(
      profileId: 6,
    ),
  ];

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: ActivityPage._homePages,
      ),
      bottomNavigationBar: _StreamagramBottomNavBar(
        pageController: pageController,
      ),
    );
  }
}

class _StreamagramBottomNavBar extends StatefulWidget {
  const _StreamagramBottomNavBar({
    Key key,
    @required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  State<_StreamagramBottomNavBar> createState() =>
      _StreamagramBottomNavBarState();
}

class _StreamagramBottomNavBarState extends State<_StreamagramBottomNavBar> {
  void _onNavigationItemTapped(int index) {
    widget.pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List bottomItems = [
      widget.pageController.page == 0
          ? "assets/images/icons/home_active_icon.svg"
          : "assets/images/icons/home_icon.svg",
      widget.pageController.page == 1
          ? "assets/images/icons/search_active_icon.svg"
          : "assets/images/icons/search_icon.svg",
      widget.pageController.page == 2
          ? "assets/images/icons/upload_active_icon.svg"
          : "assets/images/icons/upload_icon.svg",
      widget.pageController.page == 3
          ? "assets/images/icons/comment_icon.svg"
          : "assets/images/icons/comment_icon.svg",
      widget.pageController.page == 4
          ? "assets/images/icons/account_active_icon.svg"
          : "assets/images/icons/account_icon.svg",
    ];
    return BottomAppBar(
      color: widget.pageController.page == 2 ? Colors.black : Colors.white,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(bottomItems.length, (index) {
              return InkWell(
                  onTap: () {
                    _onNavigationItemTapped(index);
                    widget.pageController.page?.toInt() ?? 0;
                  },
                  child: SvgPicture.asset(
                    bottomItems[index],
                    width: 27,
                    color: widget.pageController.page == 2
                        ? Colors.white
                        : Colors.black,
                  ));
            })),
      ),
    );
  }
}
