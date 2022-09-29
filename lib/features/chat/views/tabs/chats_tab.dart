import 'package:flutter/material.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/providers/conversation_provider.dart';
import 'package:mysocial_app/features/chat/widgets/chat_tile.dart';
import 'package:provider/provider.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //context.read<ChatsProvider>().getChats();
    //List<ChatModel> chats = [];
    return Consumer<ChatsProvider>(
      builder: (context, state, _) {
        // chats = state.conversations;
        // if (chats.isEmpty) return Container();
        // List<int> userIds = [];
        // for (var chat in chats) {
        //   userIds += chat.members.map((e) => e.user_id).toList();
        // }
        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  ChatModel conversationModel = state.conversations[index];
                  return ChatItem(
                    key: Key('conversation-${conversationModel.id}'),
                    chat_id: conversationModel.chat_id,
                    members: conversationModel.users,
                    lastMessage: conversationModel.mostRecent,
                    createdAt: conversationModel.created_at,
                  );
                },
                childCount: state.conversations.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
