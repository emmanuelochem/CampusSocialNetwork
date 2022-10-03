import 'package:flutter/material.dart';

class OutgoingMessage extends StatelessWidget {
  final String message;

  const OutgoingMessage(
    this.message,
  );

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
        constraints: BoxConstraints.loose(MediaQuery.of(context).size * 0.7),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        color: Colors.green.withOpacity(.2),
        child: Text(
          message,
          softWrap: true,
          style: const TextStyle(fontSize: 15, color: Colors.green),
        ),
      ),
    );
  }
}
