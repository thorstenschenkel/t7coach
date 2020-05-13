import 'package:flutter/material.dart';
import 'package:t7coach/shared/input_constants.dart';

class SignInForm extends StatefulWidget {
  final Function toogleView;

  SignInForm({this.toogleView});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Form(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.account_box,
                color: Colors.deepOrange,
                size: 100.0,
              ),
              Text(
                'Anmeldung',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: textInputDecoration.copyWith(
                          labelText: 'E-Mail-Adresse'),
                    ),
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration:
                          textInputDecoration.copyWith(labelText: 'Passwort'),
                    ),
                    RaisedButton(
                        onPressed: () {
                          print('Email: $email');
                          print('Passwor: $password');
                        },
                        child: Text('Anmelden')),
                  ],
                ),
              ),
              Divider(
                height: 25,
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Noch kein Profil?',
                      textAlign: TextAlign.center,
                    ),
                    OutlineButton(
                      onPressed: () {
                        widget.toogleView();
                      },
                      child: Text('Registrieren'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
