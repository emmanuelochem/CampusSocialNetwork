import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({Key key}) : super(key: key);

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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          // Padding(
          //   padding: const EdgeInsets.all(3.0),
          //   child: Icon(
          //     Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          //     size: 22,
          //     color: Colors.black,
          //   ),
          // ),
          Text(
            "Profile",
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
          icon: const Icon(
            PhosphorIcons.eye,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () => null,
          icon: const Icon(
            PhosphorIcons.gear,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
