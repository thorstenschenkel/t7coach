import 'package:flutter/material.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/services/auth_service.dart';
import 'package:t7coach/shared/icon_constants.dart';
import 'package:t7coach/shared/ink_well_constants.dart';
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
              buildTopIcon(),
              Text('Anmeldung', style: headingTextStyle),
              Container(
                padding: subContainerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildErrorBox(),
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
                            labelText: 'E-Mail-Adresse', prefixIcon: Icon(Icons.alternate_email)),
                        validator: (String val) => val.isEmpty ? 'Bitte gib eine E-Mail-Adresse ein.' : null),
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
                        decoration: textInputDecoration.copyWith(labelText: 'Passwort', prefixIcon: Icon(Icons.lock)),
                        validator: (String val) => val.isEmpty ? 'Bitte gib ein Passwort ein.' : null),
                    SizedBox(height: 5),
                    RaisedButton(
                        onPressed: () async {
                          await _signIn();
                        },
                        autofocus: true,
                        child: Text('Anmelden')),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          child: Text(
                            'Passwort vergessen?',
                            style: inkWellDecoration.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/reset-password');
                          },
                        ),
                      ],
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
      setState(() {
        widget.loading(true);
      });
      _formKey.currentState.save();
      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
      if (result is AuthError) {
        setState(() {
          _autoValidate = true;
          error = result.errorText;
          _visibilityError = true;
          widget.scrollToTop();
          widget.loading(false);
        });
      }
    } else {
      setState(() {
        error = '';
        _visibilityError = false;
        _autoValidate = true;
      });
    }
  }

  Widget buildErrorBox() {
    return Visibility(
      visible: _visibilityError,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Colors.red[50],
            padding: EdgeInsets.all(8.0),
            child: Text(
              error,
              style: errorTextStyle.copyWith(color: Theme.of(context).errorColor),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget buildTopIcon() {
    return Icon(
      Icons.account_box,
      color: topIconColor,
      size: topIconSize,
    );
  }
}
