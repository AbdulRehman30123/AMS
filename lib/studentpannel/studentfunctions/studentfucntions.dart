import 'package:flutter/material.dart';

class customflashmessage extends StatelessWidget {
  customflashmessage({Key? key, required this.messagetext, required this.color})
      : super(key: key);
  String messagetext;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 90.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(children: [
        Text(
          messagetext,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        )
      ]),
    );
  }
}
