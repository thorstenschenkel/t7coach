import 'package:flutter/material.dart';
import 'package:t7coach/shared/input_constants.dart';

import 'auth_form_constants.dart';

class SignInForm extends StatefulWidget {
  final Function toogleView;

  SignInForm({this.toogleView});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: topContainerPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              topIcon,
              Text('Anmeldung',
                  style: headingTextStyle),
              Container(
                padding: subContainerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'E-Mail-Adresse',
                            prefixIcon: Icon(Icons.alternate_email)),
                        validator: (val) => val.isEmpty
                            ? 'Bitte gib eine E-Mail-Adresse ein.'
                            : null),
                    SizedBox(height: 10),
                    TextFormField(
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
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Passwort',
                            prefixIcon: Icon(Icons.lock)),
                        validator: (val) => val.isEmpty
                            ? 'Bitte gib ein Passwort ein.'
                            : null),
                    RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print('Email: $email');
                            print('Passwor: $password');
                          }
                        },
                        autofocus: true,
                        child: Text('Anmelden')),
                  ],
                ),
              ),
              divider,
              Container(
                padding: subContainerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Du hast noch kein Profil?',
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
