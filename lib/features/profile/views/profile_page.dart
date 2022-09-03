import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/features/explore/widgets/persistent_header.dart';
import 'package:mysocial_app/features/profile/providers/profile_provider.dart';
import 'package:mysocial_app/features/profile/widgets/profile_appbar.dart';
import 'package:mysocial_app/features/profile/widgets/profile_biography.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  int profileId;
  ProfilePage({Key key, @required this.profileId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileProvider profileProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileProvider = context.read<ProfileProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
          future: profileProvider.getProfile(profileId: widget.profileId),
          builder: (
            BuildContext context,
            AsyncSnapshot<Map> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              return const Text('Error 00000');
            }

            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData) {
              return const Text('Empty data');
            }

            return DefaultTabController(
              length: 4,
              child: NestedScrollView(
                  headerSliverBuilder: (context, index) {
                    return [
                      const ProfileAppBar(),
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          child: ProfileBiography(
                              profileData: snapshot.data['data']),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PersistentHeader(
                            child: const TabBar(
                              indicatorWeight: 1,
                              indicatorColor: Colors.black,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                  icon: Icon(
                                    PhosphorIcons.dots_nine_bold,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    PhosphorIcons.lightning_slash,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    PhosphorIcons.bookmarks_simple,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    PhosphorIcons.heartbeat,
                                  ),
                                ),
                              ],
                            ),
                            minExtent: 50,
                            maxExtent: 50),
                      )
                    ];
                  },
                  body: TabBarView(
                    children: [
                      CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverGrid(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60'))),
                                );
                              }),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1))
                        ],
                      ),
                      CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverGrid(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60'))),
                                );
                              }),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1))
                        ],
                      ),
                      CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverGrid(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60'))),
                                );
                              }),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1))
                        ],
                      ),
                      CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverGrid(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60'))),
                                );
                              }),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1))
                        ],
                      )
                    ],
                  )),
            );
          }),
    );
  }
}
