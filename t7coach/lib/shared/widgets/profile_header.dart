import 'package:flutter/material.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';

class ProfilHeader extends StatelessWidget {
  User user;
  UserData userData;

  ProfilHeader(this.user, this.userData) {}

  String getAccountName(UserData userData) {
    String name = userData.firstName;
    name += name.length > 0 && userData.lastName.length > 0 ? ' ' : '';
    name += userData.lastName;
    return name;
  }

  Color getCircleColor(UserData userData) {
    return userData.accountColor == null ? Colors.amber : Color(userData.accountColor);
  }

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Container(
        color: Colors.red[800],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5,2,5,2),
          child: Text(getAccountName(userData)),
        ),
      ),
      accountEmail: Container(
        color: Colors.red[800],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5,2,5,2),
          child: Text(user.email),
        ),
      ),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/bahn001.png'), fit: BoxFit.cover)),
      currentAccountPicture: new CircleAvatar(
        backgroundColor: getCircleColor(userData),
        child: Text(userData.initials, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
      ),
    );
  }
}
