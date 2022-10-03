import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';

class ChatDetailsAppBar extends StatelessWidget {
  const ChatDetailsAppBar({Key key, @required this.user}) : super(key: key);
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      //leadingWidth: 40,
      titleSpacing: 0,
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
          CircleAvatar(
              radius: 21.r,
              backgroundImage: NetworkImage(
                user.photo,
              )),
          SizedBox(
            width: 0.03.sw,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  user.nickname,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 0.003.sh,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 14.sp),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[
        //view contact
        //crush
        //kiss
        //media, links, docs
        //report
        //block
        //Clear chat
        IconButton(
          onPressed: () {},
          icon: Icon(
            PhosphorIcons.dots_three_vertical_bold,
            color: Colors.green,
            size: 35.sp,
          ),
        ),
      ],
    );
  }
}
