import 'package:flutter/material.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/services/auth_service.dart';
import 'package:t7coach/shared/input_constants.dart';

import 'auth_form_constants.dart';

class RegisterForm extends StatefulWidget {
  final Function toogleView;

  RegisterForm({this.toogleView});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: topContainerPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(child: topIcon),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.grey[700],
                      size: 30.0,
                    ),
                  ),
                ],
              ),
              Text(
                'Registrierung',
                style: headingTextStyle,
              ),
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
                          labelText: 'E-Mail-Adresse'),
                      validator: (val) {
                        return val.isEmpty
                            ? 'Bitte gib eine E-Mail-Adresse ein.'
                            : null;
                      },
                    ),
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
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Passwort'),
                        validator: (val) {
                          return val.isEmpty
                              ? 'Bitte gib ein Passwort ein.'
                              : null;
                        }),
                    SizedBox(height: 10),
                    TextFormField(
                        onChanged: (val) {
                          setState(() {
                            confirmPassword = val;
                          });
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Passwort wiederholen'),
                        validator: (val) {
                          return val.isEmpty
                              ? 'Bitte wiederhole das Passwort.'
                              : null;
                        }),
                    RaisedButton(
                        onPressed: () async {
                          error = '';
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);
                            if (result is AuthError) {
                              setState(() {
                                error = result.errorText;
                                loading = false;
                              });
                            }
                          }
                        },
                        autofocus: true,
                        child: Text('Registrieren')),
                    SizedBox(height: 8.0),
                    Text(
                      error,
                      style: errorTextStyle,
                    )
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
                      'Du hast bereits ein Profil?',
                      textAlign: TextAlign.center,
                    ),
                    OutlineButton(
                      onPressed: () {
                        widget.toogleView();
                      },
                      child: Text('Anmelden'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
