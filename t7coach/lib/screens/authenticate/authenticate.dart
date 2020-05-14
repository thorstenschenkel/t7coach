import 'package:flutter/material.dart';
import 'package:t7coach/screens/authenticate/register_form.dart';
import 'package:t7coach/screens/authenticate/sign_in_form.dart';
import 'package:t7coach/shared/widgets/coach_bar.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toogleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  Widget getForm() {
    if (showSignIn) {
      return SignInForm(toogleView: toogleView);
    } else {
      return RegisterForm(toogleView: toogleView);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget form = getForm();

    return Scaffold(
        body: Stack(children: <Widget>[
      CoachBar(210.0),
      SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 125),
              child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  child: form)))
    ]));
  }
}
