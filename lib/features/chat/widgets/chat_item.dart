import 'package:flutter/material.dart';
import 'package:mysocial_app/features/chat/views/conversation.dart';

class ChatItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String msg;
  final bool isOnline;
  final int counter;

  const ChatItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.msg,
    @required this.isOnline,
    @required this.counter,
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
        leading: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.dp,
              ),
              radius: 25,
            ),
            Positioned(
              bottom: 0.0,
              right: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 11,
                width: 11,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isOnline ? Colors.greenAccent : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 7,
                    width: 7,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(widget.name,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
        subtitle: Text(
          widget.msg,
          style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.4)),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              widget.time,
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
                      padding: const EdgeInsets.only(top: 1, left: 5, right: 5),
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
        onTap: () {
          // Navigator.push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) {
          //       return ChatDetailPage();
          //     },
          //   ),
          // );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatDetailPage()),
          );
        },
      ),
    );
  }
}
