import 'package:flutter/material.dart';

class ProfileStatsCount extends StatelessWidget {
  const ProfileStatsCount(
      {Key key, @required this.labelText, @required this.labelCount})
      : super(key: key);
  final String labelText;
  final String labelCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            labelCount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            labelText,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13.5),
          ),
        ],
      ),
    );
  }
}
