import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/activity_dashboard.dart';
import 'package:mysocial_app/composition_root.dart';
import 'package:mysocial_app/core/utils/theme_light.dart';
import 'package:mysocial_app/features/auth/providers/authDataProvider.dart';
import 'package:mysocial_app/features/auth/view/loginPage.dart';
import 'package:mysocial_app/features/auth/view/registerPage.dart';
import 'package:mysocial_app/features/auth/view/welcomePage.dart';
import 'package:mysocial_app/features/camera/providers/mediaDataProvider.dart';
import 'package:mysocial_app/features/camera/providers/publishDataProvider.dart';
import 'package:mysocial_app/features/camera/views/camera_screen.dart';
import 'package:mysocial_app/features/camera/views/gallery_screen.dart';
import 'package:mysocial_app/features/chat/providers/conversation_provider.dart';
import 'package:mysocial_app/features/explore/providers/explore_provider.dart';
import 'package:mysocial_app/features/profile/providers/profile_provider.dart';
import 'package:mysocial_app/features/timeline/providers/comments_provider.dart';
import 'package:mysocial_app/features/timeline/providers/feeds_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final firstPage = await CompositionRoot.start();

  final _datasource = CompositionRoot.chatDataSource;
  final _userService = CompositionRoot.userService;
  final _localCache = CompositionRoot.localCache;

  ChatsProvider conversationMessagesProvider =
      ChatsProvider(_datasource, _userService, _localCache);
  MediaGalleryProvider mediaGalleryProvider = MediaGalleryProvider();
  PublishDataProvider publishDataProvider = PublishDataProvider();
  FeedState feedState = FeedState();
  CommentsState commentsState = CommentsState();
  ExploreProvider exploreProvider = ExploreProvider();
  ProfileProvider profileProvider = ProfileProvider();
  AuthDataProvider authDataProvider = AuthDataProvider(_localCache);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authDataProvider),
        ChangeNotifierProvider(create: (_) => conversationMessagesProvider),
        ChangeNotifierProvider(create: (_) => mediaGalleryProvider),
        ChangeNotifierProvider(create: (_) => publishDataProvider),
        ChangeNotifierProvider(create: (_) => feedState),
        ChangeNotifierProvider(create: (_) => commentsState),
        ChangeNotifierProvider(create: (_) => exploreProvider),
        ChangeNotifierProvider(create: (_) => profileProvider),
      ],
      child: MyApp(firstPage: firstPage),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget firstPage;
  const MyApp({Key key, this.firstPage}) : super(key: key);

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
              title: 'Social Community App',
              theme: lightTheme,
              home: firstPage,
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


// class _KeepAlivePage extends StatefulWidget {
//   const _KeepAlivePage({
//     Key key,
//     @required this.child,
//   }) : super(key: key);

//   final Widget child;

//   @override
//   _KeepAlivePageState createState() => _KeepAlivePageState();
// }

// class _KeepAlivePageState extends State<_KeepAlivePage>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return widget.child;
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
