import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessagesModel message;

  const ChatBubble({
    Key key,
    this.message,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: 0.006.sh, horizontal: 0.012.sw),
          child: message.is_mine == 'true'
              ? _buildSentMessage(context)
              : _buildReceivedMessage(context),
        ),
      ],
    );
  }

  Widget _buildSentMessage(BuildContext context) {
    Color sendColor = const Color(0xff0084FF);
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 3 / 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: sendColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Text(
                message.content.trim(),
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            Icon(
              message.receipt == 'pending'
                  ? PhosphorIcons.clock
                  : message.receipt == 'sent'
                      ? PhosphorIcons.check
                      : PhosphorIcons.checks_bold,
              color: message.receipt == 'read' ? Colors.blue : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context) {
    Color receivedColor = const Color(0x99eeeeee);
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          // isMe
          //     ? Padding(
          //         padding: const EdgeInsets.only(right: 8.0),
          //         child: CircleAvatar(
          //           backgroundImage: NetworkImage(chat.from.profilePicture),
          //           radius: 12.0,
          //         ),
          //       )
          //     : Container(
          //         width: 32.0,
          //         height: 24.0,
          //       ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 3 / 4),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: receivedColor,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Text(
              message.content.trim(),
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
