import 'package:flutter/material.dart';
import 'package:mysocial_app/features/auth/auth.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';
import 'package:provider/provider.dart';

import '../../features/camera/camera.dart';

////EXTENSIONS

/// Extension method on [BuildContext] to easily manage state.
extension ProviderX on BuildContext {
  AuthDataProvider get authDataProvider => read<AuthDataProvider>();
  MediaGalleryProvider get mediaGalleryProvider => read<MediaGalleryProvider>();
  PublishDataProvider get publishDataProvider => read<PublishDataProvider>();
  UserDataProvider get userDataProvider => read<UserDataProvider>();
  FeedState get feedProvider => read<FeedState>();
  CommentsState get commentsProvider => read<CommentsState>();
}

/// Extension method on [BuildContext] to easily perform snackbar operations.
extension Snackbar on BuildContext {
  void snackBar({
    final String message,
    final String type = 'success',
  }) {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: type == 'success' ? Colors.teal : Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 10000),
      margin: const EdgeInsets.all(50),
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          //Do whatever you want
        },
      ),
      onVisible: () {
        //your code goes here
      },
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
