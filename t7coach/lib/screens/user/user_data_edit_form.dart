import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/db_error.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/loading.dart';

// https://pub.dev/packages/flutter_colorpicker#-readme-tab-

class UserDataEditForm extends StatefulWidget {
  @override
  _UserDataEditFormState createState() => _UserDataEditFormState();
}

enum CloseForm {
  YES,
  NO
}

class _UserDataEditFormState extends State<UserDataEditForm> {

  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _autoValidate = false;
  bool _visibilityError = false;
  String error = '';
  // form values
  String _firstName;
  String _lastName;
  String _initials;
  int _groupeId;
  Color _accountColor = Colors.green;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    UserData _getNewUserData(UserData userData) {
      _formKey.currentState.save();
      UserData newUserData = UserData(uid: user.uid);
      newUserData.groupeId = _groupeId ?? userData.groupeId;
      newUserData.firstName = (_firstName ?? userData.firstName).trim();
      newUserData.lastName = (_lastName ?? userData.lastName).trim();
      newUserData.initials = (_initials ?? userData.initials).trim();
      newUserData.accountColor = (_accountColor?.value ?? userData.accountColor);
      return newUserData;
    }

    void _updateInitials(UserData userData) {
      if (userData.initials.length == 0) {
        if (userData.firstName.length > 0) {
          userData.initials += userData.firstName[0];
        }
        if (userData.lastName.length > 0) {
          userData.initials += userData.lastName[0];
        }
        userData.initials = userData.initials.toUpperCase();
      }
    }

    void _scrollToTop() {
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeInSine);
    }

    _save(UserData userData) async {
      setState(() {
        _autoValidate = true;
      });
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        UserData newUserData = _getNewUserData(userData);
        _updateInitials(newUserData);
        dynamic result = await DatabaseService(uid: user.uid).updateUserData(newUserData);
        setState(() {
          _isLoading = false;
        });
        if (result is DbError) {
          setState(() {
            _autoValidate = true;
            error = result.errorText;
            _visibilityError = true;
          });
          _scrollToTop();
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/user-data-form');
        }
      } else {
        _scrollToTop();
      }
    }

    _back() {
      Navigator.of(context).popAndPushNamed('/user-data-form');
    }

    Future<CloseForm> _showMyDialog() async {
      return showDialog<CloseForm>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Daten wurden bearbeitet.'),
                  Text('Sollen die Änderungen verworfen werden?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ja'),
                onPressed: () {
                  Navigator.of(context).pop(CloseForm.YES);
                },
              ),
              FlatButton(
                child: Text('Nein'),
                onPressed: () {
                  Navigator.of(context).pop(CloseForm.NO);
                },
              ),
            ],
          );
        },
      );
    }

    Future<bool> _onWillPop(UserData userData) async {
      UserData newUserData = _getNewUserData(userData);
      if ( userData == newUserData ) {
        _back();
      } else {
        CloseForm ret = await _showMyDialog();
        if ( ret == CloseForm.YES) {
          _back();
        }
      }
      return false;
    }

    Color getCircleColor(UserData userData) {
      if (_accountColor != null) {
        return _accountColor;
      }
      return userData.accountColor == null ? Colors.amber : Color(userData.accountColor);
    }

    Widget _editButton(Function onPress) {
      return RawMaterialButton(
        onPressed: () {
          onPress();
        },
        elevation: 2.0,
        fillColor: Colors.grey,
        child: Icon(
          Icons.edit,
          size: 20.0,
        ),
        padding: EdgeInsets.all(2.0),
        shape: CircleBorder(),
      );
    }

    Widget _createHeader(UserData userData) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new CircleAvatar(
                      backgroundColor: getCircleColor(userData),
                      radius: 35,
                    ),
                  ),
                  Positioned(
                      bottom: -2,
                      right: -20,
                      child: _editButton(() {
                        setState(() {
                          _accountColor = Colors.red;
                        });
                      }))
                ],
              ),
            ],
          ),
          Divider(thickness: 2)
        ],
      );
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return WillPopScope(
              onWillPop: () async {
                return await _onWillPop(userData);
              },
              child: Scaffold(
                  appBar: AppBar(title: Text('Profil berabeiten'), elevation: 0, actions: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _save(userData);
                      },
                    ),
                  ]),
                  body: LoadingOverlay(
                    isLoading: _isLoading,
                    opacity: 0.1,
                    progressIndicator: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: <Widget>[
                          buildErrorBox(),
                          _createHeader(userData),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              autovalidate: _autoValidate,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    initialValue: userData.firstName,
                                    decoration: textInputDecoration.copyWith(labelText: 'Vorname'),
                                    keyboardType: TextInputType.text,
                                    onSaved: (String val) {
                                      setState(() {
                                        _firstName = val.trim();
                                      });
                                    },
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    initialValue: userData.lastName,
                                    decoration: textInputDecoration.copyWith(labelText: 'Nachname'),
                                    keyboardType: TextInputType.text,
                                    onSaved: (String val) {
                                      setState(() {
                                        _lastName = val.trim();
                                      });
                                    },
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    initialValue: userData.initials,
                                    decoration: textInputDecoration.copyWith(labelText: 'Initialien'),
                                    keyboardType: TextInputType.text,
                                    maxLength: 2,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    onSaved: (String val) {
                                      setState(() {
                                        _initials = val.trim();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          } else {
            return Loading();
          }
        });
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
