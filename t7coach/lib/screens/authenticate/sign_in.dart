import 'package:flutter/material.dart';
import 'package:t7coach/screens/authenticate/sign_in_form.dart';
import 'package:t7coach/shared/widgets/coach_bar.dart';

class SignIn extends StatelessWidget {
  final Function toogleView;

  SignIn({this.toogleView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      CoachBar(210.0),
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 125),
          child: Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(8.0),
              child: SignInForm()),
        ),
      ),
    ]));
  }
}
