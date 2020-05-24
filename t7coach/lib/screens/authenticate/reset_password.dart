import 'package:flutter/material.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/screens/authenticate/reset_password_icon.dart';
import 'package:t7coach/services/auth_service.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/coach_bar.dart';

import 'auth_form_constants.dart';
import 'email_sent_dlg.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _visibilityError = false;
  String email = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        CoachBar(110.0),
        SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 25),
                child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: topContainerPadding,
                        child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(children: <Widget>[
                              ResetPasswordIcon(),
                              Text('Passwort\nzurücksetzen', style: headingTextStyle, textAlign: TextAlign.center),
                              SizedBox(height: 5),
                              Text(
                                  'Gib deine E-Mail-Adresse ein\nDu erhälst eine E-Mail, mit der du dein Passwort neu setzen kannst.',
                                  style: simpleTextStyle,
                                  textAlign: TextAlign.center),
                              Container(
                                  padding: subContainerPadding,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
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
                                        validator: (String val) =>
                                            val.isEmpty ? 'Bitte gib eine E-Mail-Adresse ein.' : null),
                                    SizedBox(height: 5),
                                    RaisedButton(
                                        onPressed: () async {
                                          await _resetPassword();
                                        },
                                        autofocus: true,
                                        child: Text('Neues Passwort anfordern')),
                                  ])),
                              divider,
                              Container(
                                  padding: subContainerPadding,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      OutlineButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Zurück zur Anmeldung'),
                                      ),
                                    ],
                                  )),
                            ]))))))
      ]),
    );
  }

  void _resetPassword() async {

    if (_formKey.currentState.validate()) {
      setState(() {
        // widget.loading(true);
      });
      _formKey.currentState.save();
      dynamic result = _auth.sendPasswortResetEmail(email);
      if (result is AuthError) {
        setState(() {
          _autoValidate = true;
          error = result.errorText;
          _visibilityError = true;
          // widget.loading(false);
        });
      } else {
        await Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) {
              return new EmailSentDlg();
            },
            fullscreenDialog: true));
        Navigator.of(context).pop();
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
