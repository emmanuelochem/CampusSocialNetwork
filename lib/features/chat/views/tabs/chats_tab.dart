import 'package:flutter/material.dart';
import 'package:mysocial_app/features/chat/models/chat_model.dart';
import 'package:mysocial_app/features/chat/widgets/chat_item.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({
    Key key,
    this.conversations = const [],
  }) : super(key: key);

  final List<ChatModel> conversations;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              ChatModel conversationModel = conversations[index];
              return ChatItem(
                key: Key('conversation-${conversationModel.id}'),
                chat_id: conversationModel.chat_id,
                members: conversationModel.users,
                lastMessage: conversationModel.mostRecent,
                createdAt: conversationModel.created_at,
              );
            },
            childCount: conversations.length,
          ),
        ),
      ],
    );
  }
}
