import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: false,
      floating: true,
      centerTitle: false,
      titleSpacing: 20,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "DMs",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => null,
          icon: SvgPicture.asset(
            'assets/images/icons/discover_people.svg',
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () => null,
          icon: SvgPicture.asset(
            'assets/images/icons/discover_people.svg',
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
