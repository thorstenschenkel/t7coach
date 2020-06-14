import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/loading.dart';
import 'package:t7coach/shared/widgets/profile_header.dart';

class UserDataForm extends StatefulWidget {
  @override
  _UserDataFormState createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    DatabaseService(uid: null).getAllGroups().then((allGroups) {
      setState(() {
        groups = allGroups;
      });
    }).catchError((error) {
      print('ERROR: can not read groups because of $error');
    }).whenComplete(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    String _getInitialValue(String value) {
      String ret = value ?? '';
      if (ret.length == 0) {
        ret = ' ';
      }
      return ret;
    }

    Widget _createGroup(UserData userData) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text('Trainingsgruppe', style: heading2TextStyle, textAlign: TextAlign.left),
        SizedBox(height: 10),
        TextFormField(
            initialValue: _getInitialValue(userData.groupName),
            readOnly: true,
            decoration: _getTextInputDecoration('Gruppenname')),
      ]);
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
                appBar: AppBar(title: Text("Profil"), elevation: 0, actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/user-data-edit-form', arguments: userData);
                    },
                  ),
                ]),
                body: LoadingOverlay(
                  isLoading: _isLoading,
                  opacity: 0.75,
                  progressIndicator: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: <Widget>[
                        ProfilHeader(user, userData),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                    initialValue: _getInitialValue(userData.firstName),
                                    readOnly: true,
                                    decoration: _getTextInputDecoration('Vorname')),
                                SizedBox(height: 5),
                                TextFormField(
                                    initialValue: _getInitialValue(userData.lastName),
                                    readOnly: true,
                                    decoration: _getTextInputDecoration('Nachname')),
                                SizedBox(height: 5),
                                TextFormField(
                                    initialValue: _getInitialValue(userData.initials),
                                    readOnly: true,
                                    decoration: _getTextInputDecoration('Initialien')),
                                Divider(thickness: 1.25, height: 35),
                                _createGroup(userData)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }

  InputDecoration _getTextInputDecoration(String label) {
    InputDecoration deco = textInputDecoration.copyWith(labelText: label);
    deco = deco.copyWith(
        hintText: ' ',
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        fillColor: Theme.of(context).colorScheme.background,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)));
    return deco;
  }
}
