import 'package:flutter/material.dart';
import 'package:t7coach/screens/authenticate/authenticate.dart';
import 'package:t7coach/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = null;

    // return Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
