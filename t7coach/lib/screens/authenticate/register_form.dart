import 'package:flutter/material.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/screens/authenticate/register_icon.dart';
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
              RegisterIcon(),
              Text(
                'Registrierung',
                style: headingTextStyle,
              ),
              Container(
                padding: subContainerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildErrorBox(),
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
                          labelText: 'E-Mail-Adresse', prefixIcon: Icon(Icons.alternate_email)),
                      validator: (String val) {
                        return val.isEmpty ? 'Bitte gib eine E-Mail-Adresse ein.' : null;
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
                        decoration: textInputDecoration.copyWith(labelText: 'Passwort', prefixIcon: Icon(Icons.lock)),
                        validator: (String val) {
                          return val.isEmpty ? 'Bitte gib ein Passwort ein.' : null;
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
                            labelText: 'Passwort wiederholen', prefixIcon: Icon(Icons.lock)),
                        validator: (String val) {
                          if ( val.isEmpty) {
                            return 'Bitte wiederhole das Passwort.';
                          } else if ( val != password ) {
                            return 'Passwörter stimmen nicht überein.';
                          }
                          return null;
                        }),
                    SizedBox(height: 5),
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

  _register() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      setState(() {
        widget.loading(true);
      });
      _formKey.currentState.save();
      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
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
}
