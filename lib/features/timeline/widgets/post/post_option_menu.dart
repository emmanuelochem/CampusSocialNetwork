import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/features/timeline/timeline.dart';
import 'package:provider/provider.dart';

class PostActionMenu extends StatelessWidget {
  const PostActionMenu({Key key, @required this.post}) : super(key: key);
  final Map post;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedState>(builder: (context, state, child) {
      int item =
          state.allPosts.indexWhere((element) => element['id'] == post['id']);
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  ListCard(
                    title: state.allPosts[item]['is_bookmarked']
                        ? 'Unsave'
                        : 'Save',
                    icon: state.allPosts[item]['is_bookmarked']
                        ? PhosphorIcons.bookmark_simple_fill
                        : PhosphorIcons.bookmark_simple,
                    subtitle: 'Disable',
                    onClicked: () async {
                      Navigator.pop(context);
                      await state.togglePostBookmark(postId: post['id']);
                    },
                  ),
                  // ListCard(
                  //   title: 'Share via',

                  // subtitle: 'Diasable',
                  //   icon: PhosphorIcons.share_network,
                  //   onClicked: () {},
                  // ),
                  // ListCard(
                  //   title: 'Unfollow ${post['user']['nickname']}',
                  //   subtitle: 'Diasable',
                  //   icon: PhosphorIcons.user_minus,
                  //   onClicked: () {},
                  // ),
                  // ListCard(
                  //   title: 'Follow ${post['user']['nickname']}',
                  //   subtitle: 'Diasable',
                  //   icon: PhosphorIcons.user_plus,
                  //   onClicked: () {},
                  // ),
                  // ListCard(
                  //   title: 'Edit post',
                  //   icon: PhosphorIcons.pencil_simple,
                  //   onClicked: () {},
                  // ),
                  // ListCard(
                  //   title: 'Diasable comments',
                  //   subtitle: 'Diasable',
                  //   icon: PhosphorIcons.chat_centered_dots,
                  //   onClicked: () {},
                  // ),
                  ListCard(
                    title: 'Delete',
                    subtitle: 'Delete',
                    icon: PhosphorIcons.trash,
                    onClicked: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    const Text('Delete post',
                                        style: TextStyle(fontSize: 14)),
                                    SizedBox(
                                      height: 0.01.sh,
                                    ),
                                    const Text(
                                        'This can\'t be undone and it will be removed from your profile, the timeline of any account that follows you and from Catch Up search results.',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ])),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      await state.deletePost(
                                          postId: state.actionedPostID);
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Delete')),
                              ],
                            );
                          });
                    },
                  ),
                  // ListCard(
                  //   title: 'Mute ${post['user']['nickname']}',
                  //   icon: PhosphorIcons.prohibit,
                  //   onClicked: () {},
                  // ),
                  // ListCard(
                  //   title: 'Report this port',
                  //   icon: PhosphorIcons.megaphone,
                  //   onClicked: () {},
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ListCard extends StatelessWidget {
  const ListCard(
      {@required this.title,
      @required this.subtitle,
      this.onClicked,
      this.icon});

  final String title;
  final String subtitle;
  final IconData icon;
  final Function onClicked;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onClicked,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0,
          shadowColor: const Color.fromRGBO(0, 0, 0, .2),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            trailing: const Icon(
              PhosphorIcons.caret_right_thin,
              size: 18,
            ),
            leading: Container(
                decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                )),
            title: Text(
              title,
              style: const TextStyle(fontSize: 13),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }
}
