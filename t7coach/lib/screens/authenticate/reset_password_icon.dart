import 'package:flutter/material.dart';
import 'package:t7coach/shared/icon_constants.dart';

class ResetPasswordIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            child: Icon(
          Icons.lock,
          color: topIconColor,
          size: topIconSize,
        )),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.remove_circle,
            color: Colors.white,
            size: 30.0,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.remove_circle_outline,
            color: Colors.white,
            size: 30.0,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.refresh,
            color: Colors.grey[700],
            size: 30.0,
          ),
        ),
      ],
    );
  }
}
