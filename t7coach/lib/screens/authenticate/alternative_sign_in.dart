import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/services/auth_service.dart';

class AlternativeSignIn extends StatelessWidget {
  final AuthService _auth = AuthService();
  final buttonWidth = 125.0;
  final Function updateErrorAfterSignIn;

  AlternativeSignIn({this.updateErrorAfterSignIn});

  _signInWithGoogle() async {
    // dynamic result = await _auth.signInWithGoogle();
    // if (result is AuthError) {
    //   updateErrorAfterSignIn(result);
    // }
  }

  @override
  Widget build(BuildContext context) {

    Widget createSignInWith() {
      return Row(
        children: [
          Expanded(child: Divider(thickness: 1.5)),
          Container(margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10), child: Text('oder anmelden mit')),
          Expanded(child: Divider(thickness: 1.5))
        ],
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      createSignInWith(),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        children: [
          // GoogleSignInButton(
          //   text: "Google",
          //   centered: false,
          //   onPressed: () async {
          //     await _signInWithGoogle();
          //   },
          // ),
          SizedBox(
              width: buttonWidth,
              child: RaisedButton.icon(
                onPressed: () async {},
                icon: FaIcon(FontAwesomeIcons.facebookSquare, size: 22),
                label: Text('Facebook'),
                color: Color(0xff4267B2),
              )),
          SizedBox(
              width: buttonWidth,
              child: RaisedButton.icon(
                onPressed: () async {
                  await _signInWithGoogle();
                },
                icon: FaIcon(FontAwesomeIcons.google, size: 22),
                label: Text('Google'),
                color: Color(0xffDB4437),
              )),
          SizedBox(
              width: buttonWidth,
              child: RaisedButton.icon(
                onPressed: () async {},
                icon: FaIcon(FontAwesomeIcons.microsoft, size: 22),
                label: Text('Mircosoft'),
                color: Color(0xff00A4EF),
              )),
          SizedBox(
              width: buttonWidth,
              child: RaisedButton.icon(
                onPressed: () async {},
                icon: FaIcon(FontAwesomeIcons.twitter, size: 22),
                label: Text('Twitter'),
                color: Color(0xff1DA1F2),
              ))
        ],
      )
    ]);
  }
}
