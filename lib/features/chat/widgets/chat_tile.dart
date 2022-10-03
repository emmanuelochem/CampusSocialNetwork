import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';
import 'package:mysocial_app/features/chat/views/chat_details.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatefulWidget {
  int chat_id;
  int title;
  String createdAt;
  MessagesModel lastMessage;
  UserModel user;
  final bool isOnline;
  final int counter;

  ChatItem({
    Key key,
    this.chat_id,
    this.title,
    this.createdAt,
    this.lastMessage,
    this.user,
    this.isOnline = false,
    this.counter = 1,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          leading: Stack(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.user.photo,
                ),
                radius: 25,
              ),
              // Positioned(
              //   bottom: 0.0,
              //   right: 6.0,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(6),
              //     ),
              //     height: 11,
              //     width: 11,
              //     child: Center(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           color: widget.isOnline ? Colors.greenAccent : Colors.grey,
              //           borderRadius: BorderRadius.circular(6),
              //         ),
              //         height: 7,
              //         width: 7,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(widget.user.nickname,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                )),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    widget.lastMessage.receipt == 'sent'
                        ? PhosphorIcons.check_bold
                        : PhosphorIcons.checks_bold,
                    color: widget.lastMessage.receipt == 'read'
                        ? Colors.blue
                        : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(
                width: 3,
              ),
              Flexible(
                child: Text(
                  widget.lastMessage.content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.4),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const SizedBox(height: 10),
              Text(
                DateFormat.Hm().format(DateTime.parse(widget.createdAt)),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.4)),
              ),
              const SizedBox(height: 5),
              widget.counter == 0
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 11,
                        minHeight: 11,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 1, left: 5, right: 5),
                        child: Text(
                          "${widget.counter}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ],
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatDetailPage(
                        chatId: widget.chat_id,
                        user: widget.user,
                      )))),
    );
  }
}
