import 'package:flutter/material.dart';
import 'package:t7coach/shared/icon_constants.dart';

import 'auth_form_constants.dart';

class EmailSentDlg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _backToSignIn() {
      Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('E-Mail versendet'),
        ),
        body: Container(
            padding: topContainerPadding,
            child: Column(children: <Widget>[
              buildTopIcon(),
              Container(
                padding: subContainerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text('Du hast eine E-Mail erhalten.\nDamit kannst du dein Passwort zurücksetzen.',
                        style: simpleTextStyle, textAlign: TextAlign.center),
                    SizedBox(height: 5),
                    RaisedButton(
                        onPressed: () {
                          _backToSignIn();
                        },
                        autofocus: true,
                        child: Text('Zurück zur Anmeldung')),
                  ],
                ),
              ),
            ])));
  }

  Widget buildTopIcon() {
    return Icon(
      Icons.mail,
      color: topIconColor,
      size: topIconSize,
    );
  }
}
