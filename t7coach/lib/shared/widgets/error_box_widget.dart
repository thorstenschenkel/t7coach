import 'package:flutter/material.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';

class ErrorBoxWidget extends StatelessWidget {
  final errorMessage;

  ErrorBoxWidget(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.red[50],
          padding: EdgeInsets.all(8.0),
          child: Text(
            errorMessage,
            style: errorTextStyle.copyWith(color: Theme.of(context).errorColor),
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
