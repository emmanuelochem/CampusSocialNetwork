import 'package:flutter/material.dart';

class IncomingMessage extends StatelessWidget {
  final String message;

  const IncomingMessage(
    this.message,
  );
//0xFFEEEEEE
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: Container(
        constraints: BoxConstraints.loose(MediaQuery.of(context).size * 0.8),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        color: const Color(0xFFF3F3F4),
        child: Text(
          message,
          softWrap: true,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
