import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/widgets/incoming_chat.dart';
import 'package:mysocial_app/features/chat/widgets/outgoing_chat.dart';

class ChatBubble extends StatelessWidget {
  final MessagesModel message;

  const ChatBubble({
    Key key,
    this.message,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.0025.sh,
        //horizontal: 0.012.sw,
      ),
      child: message.is_mine == 'true'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                OutgoingMessage(
                  message.content.trim(),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IncomingMessage(
                  message.content.trim(),
                ),
              ],
            ),
    );
  }
}
