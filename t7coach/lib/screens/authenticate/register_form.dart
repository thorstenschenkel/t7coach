import 'package:flutter/material.dart';
import 'package:t7coach/shared/input_constants.dart';

class RegisterForm extends StatefulWidget {
  final Function toogleView;

  RegisterForm({this.toogleView});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    child: Icon(
                      Icons.account_box,
                      color: Colors.deepOrange,
                      size: 80.0,
                    ),
                  ),
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 42),
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
                            ? 'Bitte gebe eine E-Mail-Adresse ein.'
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
                              ? 'Bitte gebe Passwort ein.'
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
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print('Email: $email');
                            print('Passwor: $password');
                          }
                        },
                        autofocus: true,
                        child: Text('Registrieren')),
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
