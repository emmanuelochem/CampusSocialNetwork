import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mysocial_app/core/constants/constants.dart';
import 'package:mysocial_app/features/explore/providers/explore_provider.dart';
import 'package:mysocial_app/features/explore/widgets/persistent_header.dart';
import 'package:mysocial_app/features/explore/widgets/explore/explore_category_bar.dart';
import 'package:mysocial_app/features/explore/widgets/explore/explore_media_tile.dart';
import 'package:mysocial_app/features/explore/widgets/search/search_result_tile.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  final TrackingScrollController _explorePageScrollController =
      TrackingScrollController();
  final TrackingScrollController _searchPageScrollController =
      TrackingScrollController();

  // ignore: non_constant_identifier_names
  int _explore_pagination = 1;

  ExploreProvider _exploreProvider;

  @override
  void initState() {
    super.initState();
    _exploreProvider = context.read<ExploreProvider>();
    _exploreProvider.resetPost();
    _exploreProvider.fetchExplorePosts(pageNumber: _explore_pagination);
    _explorePageScrollController.addListener(() {
      if (_explorePageScrollController.position.pixels ==
          _explorePageScrollController.position.maxScrollExtent) {
        _exploreProvider.setExplorePostLoadingState(LoadMoreFeedStatus.LOADING);
        _exploreProvider.fetchExplorePosts(pageNumber: ++_explore_pagination);
      }
    });
  }

  bool isSearchActive = false;
  bool isSearchEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (context, exploreProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              controller: isSearchActive
                  ? _searchPageScrollController
                  : _explorePageScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                MultiSliver(
                  children: [
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        floating: isSearchActive ? false : true,
                        pinned: isSearchActive ? true : false,
                        centerTitle: false,
                        elevation: 0,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: 1.sw,
                            child: Row(
                              children: [
                                isSearchActive
                                    ? GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            isSearchActive = false;
                                            isSearchEmpty = true;
                                          });
                                          _searchController.text = '';
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);

                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          await exploreProvider
                                              .setSearchResult([]);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 16),
                                          child: Icon(
                                              PhosphorIcons.arrow_left_bold,
                                              color: Colors.black),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade200),
                                    child: Row(
                                      children: [
                                        isSearchActive
                                            ? const SizedBox.shrink()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Icon(
                                                  PhosphorIcons
                                                      .magnifying_glass,
                                                  size: 24,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                        Expanded(
                                          child: TextFormField(
                                            onTap: () {
                                              setState(() {
                                                isSearchActive = true;
                                              });
                                            },
                                            controller: _searchController,
                                            onChanged: (v) async {
                                              var value = v.trim();
                                              if (value.isNotEmpty) {
                                                setState(() =>
                                                    isSearchEmpty = false);
                                                await exploreProvider
                                                    .searchUsers(query: value);
                                              } else {
                                                setState(
                                                    () => isSearchEmpty = true);
                                                await exploreProvider
                                                    .setSearchResult([]);
                                              }
                                            },
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            cursorColor: Colors.grey.shade500,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              isDense: true,
                                              isCollapsed: true,
                                              hintText: "Search",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              border: InputBorder.none,
                                            ),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SliverToBoxAdapter(
                      child: Divider(
                        height: 1,
                        color: isSearchEmpty
                            ? Colors.transparent
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                isSearchActive
                    ? FutureBuilder<List>(
                        future: Future.value(exploreProvider.searchResult),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List> snapshot,
                        ) {
                          if (exploreProvider.isSearching) {
                            return SliverToBoxAdapter(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Center(child: CircularProgressIndicator()),
                                ],
                              ),
                            );
                          }

                          if (!exploreProvider.isSearching &&
                              snapshot.hasError) {
                            return const SliverToBoxAdapter(
                                child: Text('An error occured'));
                          }

                          if (!exploreProvider.isSearching &&
                              !snapshot.hasData) {
                            return const SliverToBoxAdapter(
                                child: Center(child: SizedBox.shrink()));
                          }

                          return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              //int lastItem = exploreProvider.searchResult.length - 1;
                              final result =
                                  exploreProvider.searchResult[index];
                              return ProfileSearchResult(
                                result: result,
                              );
                            }, childCount: exploreProvider.searchResult.length),
                          );
                        },
                      )
                    : MultiSliver(
                        children: [
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: PersistentHeader(
                              maxExtent: 50,
                              minExtent: 50,
                              child: CategoryBar(
                                categories: schoolLocations,
                              ),
                            ),
                          ),
                          SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 3,
                            itemCount: exploreProvider.explorePosts.length,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                            staggeredTileBuilder: (int index) {
                              int moddedIndex =
                                  index % exploreProvider.explorePosts.length;
                              int cXCellCount = moddedIndex == 11 ? 2 : 1;
                              double mXCellCount = 1;
                              if (moddedIndex == 2 || moddedIndex == 11) {
                                mXCellCount = 2;
                              }
                              return StaggeredTile.count(
                                  cXCellCount, mXCellCount);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ExploreMediaTile(
                                  postData:
                                      exploreProvider.explorePosts[index]);
                            },
                          ),
                        ],
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
