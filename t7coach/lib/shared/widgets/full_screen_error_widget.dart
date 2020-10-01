import 'package:flutter/material.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/auth_service.dart';

class FillScreenErrorWidget extends StatelessWidget {
  final AuthService _auth = AuthService();

  final String title;
  final String message;
  final bool showInternet;
  final bool showButton;

  FillScreenErrorWidget({this.title, this.message, this.showInternet = true, this.showButton = true});

  _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0,
          title: Text(title ?? 'T7 Coach'),
        ),
        body: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          message,
                          style: errorTextStyle.copyWith(color: Theme.of(context).errorColor),
                        ),
                        Visibility(
                          visible: showInternet,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                ' \u2022 Prüfe deine Internetverbindung.',
                                style: errorTextStyle.copyWith(color: Theme.of(context).errorColor),
                              ),
                              SizedBox(height: 20),
                              Text(
                                ' \u2022 Bitte melde dich ab und versuche es erneut.',
                                style: errorTextStyle.copyWith(color: Theme.of(context).errorColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: showButton,
                  child: RaisedButton(
                      onPressed: () async {
                        await _signOut();
                      },
                      child: Text('Abmelden')),
                )
              ],
            )));
  }
}
