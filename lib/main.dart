import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/app_routes.dart';
import 'package:mysocial_app/core/utils/theme_light.dart';
import 'package:mysocial_app/features/auth/providers/authDataProvider.dart';
import 'package:mysocial_app/features/camera/providers/mediaDataProvider.dart';
import 'package:mysocial_app/features/camera/providers/publishDataProvider.dart';
import 'package:mysocial_app/features/chat/providers/conversation_provider.dart';
import 'package:mysocial_app/features/explore/providers/explore_provider.dart';
import 'package:mysocial_app/features/profile/providers/profile_provider.dart';
import 'package:mysocial_app/features/timeline/providers/comments_provider.dart';
import 'package:mysocial_app/features/timeline/providers/feeds_provider.dart';
import 'package:provider/provider.dart';

import 'app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  await Firebase.initializeApp(
  //     // options: const FirebaseOptions(
  //     // apiKey: "",
  //     // authDomain: "",
  //     // databaseURL: "",
  //     // projectId: "",
  //     // storageBucket: "",
  //     // messagingSenderId: "",
  //     // appId: "",
  //     // measurementId: ""),
  //     );

  await AppConfig.configure();
  final homePage = await AppConfig.start();
  final _chatService = AppConfig.chatService;
  final _userService = AppConfig.userService;
  final _localCache = AppConfig.localCache;
  final _socketService = AppConfig.socketService;

  ChatsProvider _chatsProvider =
      ChatsProvider(_chatService, _userService, _localCache, _socketService);
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
        ChangeNotifierProvider(create: (_) => _chatsProvider),
        ChangeNotifierProvider(create: (_) => mediaGalleryProvider),
        ChangeNotifierProvider(create: (_) => publishDataProvider),
        ChangeNotifierProvider(create: (_) => feedState),
        ChangeNotifierProvider(create: (_) => commentsState),
        ChangeNotifierProvider(create: (_) => exploreProvider),
        ChangeNotifierProvider(create: (_) => profileProvider),
      ],
      child: MyApp(firstPage: homePage),
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
            theme: lightTheme,
            title: 'The Social Community',
            home: AppSetup(firstPage: firstPage),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) => generateRoute(settings),
          ),
        );
      },
    );
  }
}

class AppSetup extends StatefulWidget {
  final Widget firstPage;
  const AppSetup({Key key, this.firstPage}) : super(key: key);
  @override
  State<AppSetup> createState() => _AppSetupState();
}

class _AppSetupState extends State<AppSetup> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // if (message.notification != null) {
    //context.read<ChatsProvider>().offlineMessage(message.notification);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return widget.firstPage;
  }
}

// WidgetsBinding.instance?.addPostFrameCallback((_) {
//   });
