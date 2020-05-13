import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toogleView;

  Register({this.toogleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Registrierung'));
  }
}
