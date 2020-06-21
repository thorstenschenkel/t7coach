import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/auth_service.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/widgets/full_screen_error_widget.dart';
import 'package:t7coach/shared/widgets/loading.dart';
import 'package:t7coach/shared/widgets/profile_header.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final AuthService _auth = AuthService();

    _signOut() async {
      await _auth.signOut();
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
      String name = packageInfo.appName;
      name = 'T7 Coach';
      String version = packageInfo.version;
      version += ' (${packageInfo.buildNumber})';
      showAboutDialog(context: context, applicationName: name, applicationVersion: version);
    }

    print('user ${user.uid}');

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return Scaffold(
                appBar: new AppBar(
                  elevation: 0,
                  title: Text( 'T7 Coach')
                ),
                drawer: new Drawer(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            ProfilHeader(user, userData),
                            ListTile(
                              title: Text('Profil'),
                              leading: Icon(Icons.account_box),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed('/user-data-form');
                              },
                            ),
                            ListTile(
                              title: Text('Trainingsgruppe'),
                              leading: Icon(Icons.group),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed('/group-form', arguments: userData);
                              },
                            ),
                            Visibility(
                              visible: userData.isCoach(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Divider(thickness: 2, height: 2),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Trainer', style: heading3TextStyle, textAlign: TextAlign.left),
                                  ),
                                  ListTile(
                                    title: Text('Neue Trainingseinheit'),
                                    leading: Icon(Icons.add),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed('/add-training');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(thickness: 2, height: 2),
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
            } else {
              return Loading();
            }
          } else {
            return FillScreenErrorWidget(title: null, message: 'Daten des Profils können nicht gelesen werden');
          }
        });
  }
}
