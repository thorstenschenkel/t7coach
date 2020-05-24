import 'package:flutter/material.dart';

class CoachBar extends StatelessWidget {
  final double height;
  final bool bgImage;

  CoachBar(this.height, {this.bgImage = false});

  BoxDecoration getDecoration() {
    if (this.bgImage) {
      return BoxDecoration(image: DecorationImage(image: AssetImage('assets/bahn001.png'), fit: BoxFit.cover));
    } else {
      return BoxDecoration(
          gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepOrange, Colors.deepOrange[100]],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: getDecoration(),
          height: height,
        ),
      ],
    );
  }
}
