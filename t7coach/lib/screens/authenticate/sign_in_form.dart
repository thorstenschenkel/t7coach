import 'package:flutter/material.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/services/auth_service.dart';
import 'package:t7coach/shared/input_constants.dart';

import 'auth_form_constants.dart';

class SignInForm extends StatefulWidget {
  final Function toogleView;
  final Function scrollToTop;
  final Function loading;

  SignInForm({this.toogleView, this.scrollToTop, this.loading});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _visibilityError = false;
  String email = '';
  String password = '';
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
              topIcon,
              Text('Anmeldung', style: headingTextStyle),
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
                        onSaved: (String val) {
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
                        validator: (String val) => val.isEmpty
                            ? 'Bitte gib eine E-Mail-Adresse ein.'
                            : null),
                    SizedBox(height: 10),
                    TextFormField(
                        onSaved: (String val) {
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
                        validator: (String val) =>
                            val.isEmpty ? 'Bitte gib ein Passwort ein.' : null),
                    RaisedButton(
                        onPressed: () async {
                          await _signIn();
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

  void _signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_formKey.currentState.validate()) {
        setState(() {
          widget.loading(true);
        });
        _formKey.currentState.save();
        dynamic result =
            await _auth.signInWithEmailAndPassword(email, password);
        if (result is AuthError) {
          setState(() {
            _autoValidate = true;
            error = result.errorText;
            _visibilityError = true;
            widget.scrollToTop();
            widget.loading(false);
          });
        }
      }
    } else {
      setState(() {
        _visibilityError = false;
        _autoValidate = true;
      });
    }
  }
}
