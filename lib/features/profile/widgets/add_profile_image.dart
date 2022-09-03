import 'package:flutter/material.dart';

class AddProfileImage extends StatefulWidget {
  String image;
  AddProfileImage({Key key, @required this.image}) : super(key: key);

  @override
  State<AddProfileImage> createState() => _AddProfileImageState();
}

class _AddProfileImageState extends State<AddProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Colors.pink,
          radius: 45,
          backgroundImage: NetworkImage(widget.image),
        ),
        // Positioned(
        //     top: 65,
        //     left: 65,
        //     child: Container(
        //       height: 25,
        //       width: 25,
        //       decoration: BoxDecoration(
        //           border: Border.all(color: Colors.white, width: 3),
        //           borderRadius: BorderRadius.circular(15),
        //           color: Colors.blue),
        //       child: IconButton(
        //         padding: EdgeInsets.zero,
        //         onPressed: () {},
        //         icon: const Icon(Icons.add),
        //         iconSize: 20,
        //         color: Colors.white,
        //       ),
        //     ))
      ],
    );
  }
}
