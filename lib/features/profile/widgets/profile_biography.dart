import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/features/profile/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import 'add_profile_image.dart';
import 'profile_stats_count.dart';

class ProfileBiography extends StatefulWidget {
  const ProfileBiography({Key key, @required this.profileData})
      : super(key: key);

  final Map profileData;
  @override
  State<ProfileBiography> createState() => _ProfileBiographyState();
}

class _ProfileBiographyState extends State<ProfileBiography> {
  bool isStoryTrayOpen = false;
  bool isFollowing = false;

  ProfileProvider _profileProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFollowing = widget.profileData['is_followed'];
    _profileProvider = context.read<ProfileProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AddProfileImage(image: widget.profileData['photo']),
              const SizedBox(
                width: 8,
              ),
              ProfileStatsCount(
                labelCount: '${widget.profileData['posts_count']}',
                labelText: 'Crush',
              ),
              ProfileStatsCount(
                labelCount: '${widget.profileData['followers_count']}',
                labelText: 'Followers',
              ),
              ProfileStatsCount(
                labelCount: '${widget.profileData['following_count']}',
                labelText: 'Following',
              ),
            ],
          ),
        ),

        //Bio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.profileData['nickname']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'A software developer - Just a regular teenager. Cute, easy-going, introverted, loves music... Ed sheeran. ',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          PhosphorIcons.trend_up,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${widget.profileData['levels']['name']}',
                            style: const TextStyle(
                              fontSize: 14,
                            )),
                      ],
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Row(
                      children: [
                        const Icon(
                          PhosphorIcons.graduation_cap_bold,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${widget.profileData['departments']['name']}',
                            style: const TextStyle(
                              fontSize: 14,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        //Follow block
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.profileData['is_self']
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(5),
                          //color: Colors.blue
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                    )
                  : Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (isFollowing) {
                            setState(() => isFollowing = false);
                            await _profileProvider.unfollowUser(
                                userId: widget.profileData['id']);
                          } else {
                            setState(() => isFollowing = true);
                            await _profileProvider.followUser(
                                userId: widget.profileData['id']);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).primaryColor),
                          child: Text(
                            isFollowing ? 'Unfollow' : 'Follow',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5),
                  //color: Colors.blue
                ),
                child: const Icon(
                  PhosphorIcons.heart,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5),
                  //color: Colors.blue
                ),
                child: const Icon(
                  Icons.expand_more_outlined,
                ),
              ),
            ],
          ),
        ),

        //Story Highlight,
        ExpansionTile(
          title: const Text(
            'Story highlight',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          onExpansionChanged: (isOpen) {
            setState(() {
              isStoryTrayOpen = isOpen;
            });
          },
          subtitle: isStoryTrayOpen
              ? const Text(
                  'Keep your favourite stories on your profile',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                )
              : null,
          trailing: isStoryTrayOpen
              ? const Icon(
                  Icons.expand_less_outlined,
                )
              : Icon(Icons.expand_more_outlined, color: Colors.grey.shade500),
          children: [
            SizedBox(
              height: 80,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? SizedBox(
                            width: 80,
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  'New',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 80,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300,
                            ),
                          );
                  }),
            ),
          ],
        ),
        Divider(
          height: 1,
          color: isStoryTrayOpen ? Colors.transparent : Colors.grey.shade400,
        ),
      ],
    );
  }
}
