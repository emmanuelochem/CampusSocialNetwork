import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysocial_app/core/utils/theme_light.dart';
import 'package:mysocial_app/features/auth/view/loginPage.dart';
import 'package:mysocial_app/features/auth/view/registerPage.dart';
import 'package:mysocial_app/features/auth/view/splashScreenPage.dart';
import 'package:mysocial_app/features/auth/view/welcomePage.dart';
import 'package:mysocial_app/features/camera/views/camera_screen.dart';
import 'package:mysocial_app/features/camera/views/gallery_screen.dart';
import 'package:mysocial_app/features/chat/views/chats.dart';
import 'package:mysocial_app/features/explore/providers/explore_provider.dart';
import 'package:mysocial_app/features/explore/views/explore_page.dart';
import 'package:mysocial_app/features/profile/providers/profile_provider.dart';
import 'package:mysocial_app/features/profile/views/profile_page.dart';
import 'package:mysocial_app/features/timeline/views/feeds_page.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth.dart';
import 'features/camera/camera.dart';
import 'features/timeline/timeline.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException {
    //print('Error in fetching the cameras: $e');
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthDataProvider()),
      ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ChangeNotifierProvider(create: (_) => MediaGalleryProvider()),
      ChangeNotifierProvider(create: (_) => PublishDataProvider()),
      ChangeNotifierProvider(create: (_) => FeedState()),
      ChangeNotifierProvider(create: (_) => CommentsState()),
      ChangeNotifierProvider(create: (_) => ExploreProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: MaterialApp(
              title: 'Flutter Demo',
              theme: lightTheme,
              home: SplashScreenPage(),
              routes: {
                '/welcome': (context) => const WelcomePage(),
                '/register': (context) => const RegisterPage(),
                '/login': (context) => const LoginPage(),
                '/home': (context) => const ActivityPage(),
                '/camera': (context) => CameraScreen(),
                '/gallery': (context) => GalleryScreen(),
              }),
        );
      },
    );
  }
}

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
  final double iconSize = 30;
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

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
