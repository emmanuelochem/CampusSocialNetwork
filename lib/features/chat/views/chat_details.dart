import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';
import 'package:mysocial_app/features/chat/providers/conversation_provider.dart';
import 'package:mysocial_app/features/chat/widgets/chat_bubble.dart';
import 'package:mysocial_app/features/chat/widgets/chat_details_appbar.dart';
import 'package:mysocial_app/features/chat/widgets/chat_message_box.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  final int chatId;
  final UserModel user;

  const ChatDetailPage({Key key, @required this.chatId, @required this.user})
      : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ChatsProvider>().getMessages(chatId: widget.chatId);
    // context.read<ChatsProvider>().getActiveChatUSer(userId: widget.user.user_id);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatsProvider>(
        builder: (context, state, _) {
          return CustomScrollView(
            // controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              ChatDetailsAppBar(user: widget.user),

              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (context, index) {
              //       final message = state.messages[index];
              //       return ChatBubble(
              //         key: ValueKey('message-${message.message_uuid}'),
              //         message: message,
              //       );
              //     },
              //     childCount: state.messages.length,
              //   ),
              // ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                          right: 20,
                          left: 20,
                          top: 20,
                          bottom: 80,
                        ),
                        children: List.generate(
                          1 + state.messages.length,
                          (index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CircleAvatar(
                                        radius: 60.r,
                                        backgroundImage: NetworkImage(
                                          widget.user.photo,
                                        )),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      widget.user.nickname,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      widget.user.department_name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      widget.user.level_name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints.loose(
                                            MediaQuery.of(context).size * 0.8),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        color: const Color(0xFFF3F3F4),
                                        child: const Text(
                                          'View Profile',
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                              );
                            }
                            final message = state.messages[index - 1];
                            return ChatBubble(
                              key: ValueKey('message-${message.message_uuid}'),
                              message: message,
                            );
                          },
                        ),
                      ),
                    ),
                    ChatMessageBox(
                      chatId: widget.chatId,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
