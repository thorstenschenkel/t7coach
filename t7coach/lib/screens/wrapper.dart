import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/screens/authenticate/authenticate.dart';
import 'package:t7coach/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
