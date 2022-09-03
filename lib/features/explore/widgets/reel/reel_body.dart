import 'package:flutter/material.dart';
import 'package:mysocial_app/features/explore/widgets/reel/reel_action_bar.dart';
import 'package:mysocial_app/features/explore/widgets/reel/reel_details.dart';

class ReelContentBody extends StatelessWidget {
  const ReelContentBody({Key key, @required this.post}) : super(key: key);

  final Map post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(post['image']),
        ),
      ),
      child: Stack(
        children: [
          _topDarkGradient(),
          _bottomDarkGradient(),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
              right: 8,
              left: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 19,
                      child: ReelDetails(
                        post: post,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ReelActionBar(
                        post: post,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topDarkGradient() => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                begin: const Alignment(0, -0.99),
                end: const Alignment(0, -0.7))),
      );

  Widget _bottomDarkGradient() => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                end: const Alignment(0, 0.7),
                begin: const Alignment(0, 0.99))),
      );
}
