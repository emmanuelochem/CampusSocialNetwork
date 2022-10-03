import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/features/chat/providers/conversation_provider.dart';
import 'package:mysocial_app/features/chat/widgets/share_option_item.dart';
import 'package:provider/provider.dart';

class ChatMessageBox extends StatefulWidget {
  const ChatMessageBox({Key key, @required this.chatId}) : super(key: key);
  final int chatId;

  @override
  State<ChatMessageBox> createState() => _ChatMessageBoxState();
}

class _ChatMessageBoxState extends State<ChatMessageBox> {
  final TextEditingController _textEditingController = TextEditingController();

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

  bool showOptions = false;
  bool inputActive = false;
  bool emojiShowing = false;

  final FocusNode _formFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Divider(
          //   height: 1,
          //   color: Colors.grey.shade400,
          // ),
          Container(
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        inputActive = false;
                        showOptions = !showOptions;
                      });
                    },
                    child: inputActive
                        ? Container(
                            padding: const EdgeInsets.all(0),
                            child: Icon(
                              PhosphorIcons.caret_right,
                              color: Colors.green,
                              size: 25.sp,
                            ),
                          )
                        : Container(
                            padding: showOptions
                                ? const EdgeInsets.all(6)
                                : EdgeInsets.zero,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: showOptions
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.transparent,
                            ),
                            child: Icon(
                              showOptions
                                  ? PhosphorIcons.x
                                  : PhosphorIcons.plus,
                              color: Colors.green,
                              size: 22.sp,
                            ),
                          ),
                  ),
                  SizedBox(
                    width: 0.03.sw,
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: const Color(0xFFEBEEF3),
                          borderRadius: BorderRadius.circular(50)),
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            inputActive = true;
                          });
                        },
                        focusNode: _formFocus,
                        onChanged: (text) {
                          setState(() {
                            if (_textEditingController.text.trim().isEmpty) {
                              showOptions = false;
                              inputActive = false;
                            } else {
                              if (!inputActive) {
                                showOptions = false;
                                inputActive = true;
                              }
                            }
                          });
                        },
                        // textInputAction: TextInputAction.newline,
                        // keyboardType: TextInputType.multiline,
                        // maxLines: 5,
                        cursorColor: Colors.black,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          prefixIcon: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  emojiShowing = !emojiShowing;
                                  if (emojiShowing) {
                                    _formFocus.unfocus();
                                  } else {
                                    _formFocus.requestFocus();
                                  }
                                });
                              },
                              icon: const Icon(
                                PhosphorIcons.smiley,
                                color: Colors.green,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  (_textEditingController.text.trim().isNotEmpty)
                      ? Row(
                          children: [
                            SizedBox(
                              width: 0.03.sw,
                            ),
                            GestureDetector(
                              onTap: () => _sendNewMessage(),
                              child: Icon(
                                PhosphorIcons.paper_plane_right_fill,
                                size: 28.sp,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
          showOptions
              ? Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F4).withOpacity(0.5)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ShareOptionItem(
                        title: 'Camera',
                        icon: PhosphorIcons.camera,
                        primaryColor: Colors.red,
                        secondaryColor: Colors.red[700],
                        onTapped: () {},
                      ),
                      ShareOptionItem(
                        title: 'Gallery',
                        icon: PhosphorIcons.image,
                        primaryColor: Colors.deepPurple,
                        secondaryColor: Colors.deepPurple[700],
                        onTapped: () {},
                      ),
                      ShareOptionItem(
                        title: 'Documents',
                        icon: PhosphorIcons.paperclip,
                        primaryColor: Colors.blue,
                        secondaryColor: Colors.blue[700],
                        onTapped: () {},
                      ),
                      ShareOptionItem(
                        title: 'Audio',
                        icon: PhosphorIcons.map_pin,
                        primaryColor: Colors.pink,
                        secondaryColor: Colors.pink[700],
                        onTapped: () {},
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
