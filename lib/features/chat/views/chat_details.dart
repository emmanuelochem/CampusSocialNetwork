import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/features/chat/providers/conversation_provider.dart';
import 'package:mysocial_app/features/chat/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  final int chatId;

  const ChatDetailPage({Key key, @required this.chatId}) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ChatsProvider>().getMessages(chatId: widget.chatId);
  }

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: getBody(),
      bottomSheet: getBottom(),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.2),
      elevation: 0,
      leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
          )),
      title: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80"),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Alina",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "Online",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.4), fontSize: 14),
              )
            ],
          )
        ],
      ),
      actions: <Widget>[
        const Icon(
          PhosphorIcons.phone,
          color: Colors.green,
          size: 32,
        ),
        const SizedBox(
          width: 15,
        ),
        const Icon(
          PhosphorIcons.video_camera,
          color: Colors.green,
          size: 35,
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white38)),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Widget getBody() {
    return Consumer<ChatsProvider>(
      builder: (context, state, _) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                //reverse: true,
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 20,
                  bottom: 80,
                ),
                children: List.generate(state.messages.length, (index) {
                  return ChatBubble(
                    message: state.messages[index],
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getBottom() {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50)),
                child: TextFormField(
                  onChanged: (text) {},
                  // textInputAction: TextInputAction.newline,
                  // keyboardType: TextInputType.multiline,
                  // maxLines: 5,
                  cursorColor: Colors.black,
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      PhosphorIcons.smiley,
                      color: Colors.green,
                      size: 25,
                    ),
                    hintText: "Say Something...",
                    suffixIcon: Icon(
                      PhosphorIcons.paperclip,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 0.03.sw,
            ),
            GestureDetector(
              onTap: () => _sendNewMessage(),
              child: Icon(
                PhosphorIcons.paper_plane_right,
                size: 28.sp,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendNewMessage() async {
    if (_textEditingController.text.trim().isEmpty) return;
    Map<String, dynamic> data = {
      'content': _textEditingController.text.trim().toString(),
      'receiver_id': 9,
      'time': DateTime.now().toString()
    };
    await context
        .read<ChatsProvider>()
        .sendMessage(message: data, chatId: widget.chatId);
    _textEditingController.text = '';
  }
}
