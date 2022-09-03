import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class NoComments extends StatelessWidget {
  const NoComments({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              PhosphorIcons.chat_centered_dots,
              size: 80,
              color: Colors.black45,
            )
          ],
        ),
        const SizedBox(height: 25),
        const Text(
          "No comment here",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        const Text(
          "Be the first to comment",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
