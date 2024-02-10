import 'package:flutter/material.dart';

class reusable extends StatelessWidget {
  final Color colour;
  reusable(
      {required this.colour, required this.cardChild, required this.onpress});

  final Widget cardChild;

  final Function() onpress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        child: cardChild,
//color: Colors.red,

        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          //color: Color(0xFF101E33),
          color: colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
