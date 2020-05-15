import 'package:flutter/material.dart';
import 'package:t7coach/services/auth_service.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            RaisedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text('Abmelden'),
            )
          ],
        ),
      ),
    );
  }
}
