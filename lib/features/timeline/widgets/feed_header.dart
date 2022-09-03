import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedHeader extends StatelessWidget {
  const FeedHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      pinned: true,
      centerTitle: false,
      //floating: true,
      title: Text("Catch Up",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          )),
      actions: [
        Container(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/images/icons/bell.svg',
            width: 22,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Function onPressed;

  const CircleButton({
    Key key,
    @required this.icon,
    @required this.iconSize,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: iconSize,
        color: Colors.black,
        onPressed: onPressed,
      ),
    );
  }
}
