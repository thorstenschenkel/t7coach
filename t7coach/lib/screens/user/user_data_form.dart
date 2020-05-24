import 'package:flutter/material.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';

class UserDataForm extends StatefulWidget {
  @override
  _UserDataFormState createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  int groupePin = -1;
  String groupeId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Profil')),
        body: Container(
            padding: topContainerPadding,
            child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(children: <Widget>[
                  DropdownButtonFormField()
                ]))));
  }
}
