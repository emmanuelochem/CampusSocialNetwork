import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class ReelProfileImage extends StatefulWidget {
  String image;
  ReelProfileImage({Key key, @required this.image}) : super(key: key);

  @override
  State<ReelProfileImage> createState() => _AddProfileImageState();
}

class _AddProfileImageState extends State<ReelProfileImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.pink,
              radius: 25,
              backgroundImage: NetworkImage(widget.image),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 15,
              child: Center(
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: const Icon(PhosphorIcons.check),
                      iconSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
