import 'package:flutter/material.dart';
import 'package:mysocial_app/features/chat/views/tabs/chats_tab.dart';
import 'package:mysocial_app/features/chat/views/tabs/status_tab.dart';
import 'package:mysocial_app/features/chat/widgets/chats_appbar.dart';
import 'package:mysocial_app/features/explore/widgets/persistent_header.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: SafeArea(
      child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (context, index) {
                return [
                  const ChatAppBar(),
                  // const SliverToBoxAdapter(
                  //   child: ChatsSearch(),
                  // ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PersistentHeader(
                        child: const ColoredBox(
                          color: Colors.white,
                          child: TabBar(
                            indicatorWeight: 1,
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(
                                text: 'CHATS',
                              ),
                              Tab(
                                text: 'STATUS',
                              ),
                            ],
                          ),
                        ),
                        minExtent: 50,
                        maxExtent: 50),
                  )
                ];
              },
              body: const TabBarView(
                children: [
                  ChatsTab(),
                  StatusTab(),
                ],
              ))),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
