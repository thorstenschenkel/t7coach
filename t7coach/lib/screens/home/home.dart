import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/services/auth_service.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // final userData = Provider.of<UserData>(context);
    final AuthService _auth = AuthService();

    _signOut() async {
      await _auth.signOut();
    }

    Widget _createDrawerHeader() {
      return UserAccountsDrawerHeader(
        accountEmail: Text(user.email),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/bahn001.png'), fit: BoxFit.cover)),
        currentAccountPicture: new CircleAvatar(
          backgroundColor: Colors.brown,
          child: Text('TS'),
        ),
      );
    }

    Widget _createDrawerFooter() {
      return Container(
        color: Theme.of(context).colorScheme.primary,
        child: ListTile(
          title: Text('Abmelden', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          leading: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.onPrimary),
          onTap: () async {
            Navigator.of(context).pop();
            await _signOut();
          },
        ),
      );
    }

    void _showAbout() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String name =   packageInfo.appName;
      name = 'T7 Coach';
      String version = packageInfo.version;
      version += ' (${packageInfo.buildNumber})';
      showAboutDialog(
          context: context,
          applicationName: name,
          applicationVersion: version);
    }

    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
      ),
      drawer: new Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _createDrawerHeader(),
                  ListTile(
                    title: Text('Profil'),
                    leading: Icon(Icons.account_box),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/user-data-form');
                    },
                  ),
                  ListTile(
                    title: Text('About'),
                    leading: Icon(Icons.info_outline),
                    onTap: () async {
                      _showAbout();
                    },
                  )
                ],
              ),
            ),
            _createDrawerFooter()
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            RaisedButton(
              onPressed: () async {
                await _signOut();
              },
              child: Text('Abmelden'),
            )
          ],
        ),
      ),
    );
  }
}
