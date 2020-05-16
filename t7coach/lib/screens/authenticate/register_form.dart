import 'package:flutter/material.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/services/auth_service.dart';
import 'package:t7coach/shared/input_constants.dart';

import 'auth_form_constants.dart';

class RegisterForm extends StatefulWidget {
  final Function toogleView;
  final Function scrollToTop;
  final Function loading;

  RegisterForm({this.toogleView, this.scrollToTop, this.loading});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _visibilityError = false;
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
          autovalidate: _autoValidate,
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
                    Visibility(
                      visible: _visibilityError,
                      child: Column(
                        children: <Widget>[
                          Text(
                            error,
                            style: errorTextStyle.copyWith(
                                color: Theme.of(context).errorColor),
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                    TextFormField(
                      onChanged: (String val) {
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
                      validator: (String val) {
                        return val.isEmpty
                            ? 'Bitte gib eine E-Mail-Adresse ein.'
                            : null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                        onChanged: (String val) {
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
                            textInputDecoration.copyWith(labelText: 'Passwort',
                                prefixIcon: Icon(Icons.lock)),
                        validator: (String val) {
                          return val.isEmpty
                              ? 'Bitte gib ein Passwort ein.'
                              : null;
                        }),
                    SizedBox(height: 10),
                    TextFormField(
                        onSaved: (String val) {
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
                            labelText: 'Passwort wiederholen',
                            prefixIcon: Icon(Icons.lock)),
                        validator: (String val) {
                          return val.isEmpty
                              ? 'Bitte wiederhole das Passwort.'
                              : null;
                        }),
                    RaisedButton(
                        onPressed: () async {
                          await _register();
                        },
                        autofocus: true,
                        child: Text('Registrieren')),
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

  void _register() async {
    error = '';
    if (_formKey.currentState.validate()) {
      setState(() {
        widget.loading(true);
      });
      _formKey.currentState.save();
      dynamic result =
          await _auth.registerWithEmailAndPassword(email, password);
      if (result is AuthError) {
        setState(() {
          _autoValidate = true;
          _visibilityError = true;
          error = result.errorText;
          widget.scrollToTop();
          widget.loading(false);
        });
      }
    } else {
      setState(() {
        _visibilityError = false;
        _autoValidate = true;
      });
    }
  }
}
