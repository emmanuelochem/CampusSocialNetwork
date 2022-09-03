import 'package:flutter/material.dart';
import 'package:mysocial_app/features/profile/api/profile_api.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileApi _profileApi = ProfileApi();

  Future<Map> getProfile({int profileId}) async {
    var res = await _profileApi.getProfile(profileId: profileId);
    return res;
  }

  Future<Map> followUser({int userId}) async {
    Map follow = await _profileApi.followUser(
      userID: userId,
    );
    return follow;
  }

  Future<Map> unfollowUser({int userId}) async {
    Map unfollow = await _profileApi.unfollowUser(
      userID: userId,
    );
    return unfollow;
  }

  Future<Map> crushUser({int userId}) async {
    Map follow = await _profileApi.crushUser(
      userID: userId,
    );
    return follow;
  }

  Future<Map> uncrushUser({int userId}) async {
    Map unfollow = await _profileApi.uncrushUser(
      userID: userId,
    );
    return unfollow;
  }
}
