import 'package:flutter/material.dart';

class CoachBar extends StatelessWidget {
  final double height;

  CoachBar(this.height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.amber, Colors.amber[100]],
            ),
          ),
          height: height,
        ),
//        AppBar(
//          backgroundColor: Colors.transparent,
//          elevation: 0.0,
//          centerTitle: true,
//          title: new Text(
//            "AirAsia",
//            style: TextStyle(
//                fontFamily: 'NothingYouCouldDo', fontWeight: FontWeight.bold),
//          ),
//        ),
      ],
    );
  }
}
