import 'package:flutter/material.dart';
import 'package:t7coach/shared/icon_constants.dart';

class RegisterIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(child: buildTopIcon()),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.add_circle_outline,
            color: Colors.white,
            size: 30.0,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.add_circle,
            color: Colors.grey[700],
            size: 30.0,
          ),
        ),
      ],
    );
  }

  Widget buildTopIcon() {
    return Icon(
      Icons.account_box,
      color: topIconColor,
      size: topIconSize
    );
  }
}
