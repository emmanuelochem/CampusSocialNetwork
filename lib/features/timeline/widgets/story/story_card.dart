import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({
    Key key,
    @required this.story,
  }) : super(key: key);
  final Map story;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange, Colors.yellow.shade800]),
              border: Border.all(width: 2, color: Colors.transparent),
              borderRadius: BorderRadius.circular(50)),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 32,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 30,
              backgroundImage: NetworkImage("${story['userimg']}"),
            ),
          ),
        ),
        const Spacer(),
        Text(
          story['username'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
