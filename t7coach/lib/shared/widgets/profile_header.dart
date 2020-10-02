import 'package:flutter/material.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';

class ProfilHeader extends StatelessWidget {
  User user;
  UserData userData;

  ProfilHeader(this.user, this.userData);

  Color getCircleColor(UserData userData) {
    return userData.accountColor == null ? Colors.amber : Color(userData.accountColor);
  }

  Color _getBackgroundcolorOfAccountName(UserData userData) {
    return userData.isFullNameEmpty() ? Colors.transparent : Colors.red[800];
  }

  CircleAvatar _createCircleAvatar(
    User user,
    UserData userData,
  ) {
    if (user.photoUrl == null) {
      return new CircleAvatar(
          backgroundColor: getCircleColor(userData),
          child: Text(userData.initials, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)));
    } else {
      return new CircleAvatar(backgroundImage: NetworkImage(user.photoUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Container(
        color: _getBackgroundcolorOfAccountName(userData),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Text(userData.getFullName()),
        ),
      ),
      accountEmail: Container(
        color: Colors.red[800],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Text(user.email),
        ),
      ),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/bahn001.png'), fit: BoxFit.cover)),
      currentAccountPicture: _createCircleAvatar(user, userData)
    );
  }
}
