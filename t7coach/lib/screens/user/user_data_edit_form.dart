import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/db_error.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/dialogs/color_picker_dialog_util.dart';
import 'package:t7coach/shared/dialogs/discard_changes_dialog_util.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/full_screen_error_widget.dart';
import 'package:t7coach/shared/widgets/loading.dart';

class UserDataEditForm extends StatefulWidget {
  final UserData userData;

  UserDataEditForm(this.userData);

  @override
  _UserDataEditFormState createState() => _UserDataEditFormState();
}

class _UserDataEditFormState extends State<UserDataEditForm> {
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _autoValidate = false;
  bool _visibilityError = false;
  String error = '';
  List<Group> groups;

  // form values
  String _firstName;
  String _lastName;
  String _initials;
  String _groupName;
  String _groupPin;
  String _coachGroupName;
  Color _accountColor;
  bool _pinVisibility;

  bool _isGroupPinRequired(UserData userData) {
    return userData.groupName == null || userData.groupName.isEmpty || _groupName != userData.groupName;
  }

  @override
  void initState() {
    super.initState();
    _groupName = widget.userData.groupName;
    _pinVisibility = _isGroupPinRequired(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    UserData _getNewUserData(UserData userData) {
      _formKey.currentState.save();
      UserData newUserData = UserData(uid: user.uid);
      newUserData.groupName = _groupName ?? userData.groupName;
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
      _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInSine);
    }

    void _setError(String text) {
      setState(() {
        error = text;
        _visibilityError = true;
      });
      _scrollToTop();
      setState(() {
        _isLoading = false;
      });
    }

    bool _checkPin() {
      bool okay = true;
      if (_pinVisibility) {
        Group group = groups.firstWhere((group) => group.name == _groupName, orElse: null);
        if (group == null) {
          okay = false;
        }
        okay = group.pin == _groupPin;
      }
      if (!okay) {
        _setError('Die PIN der Trainingsgruppe ist falsch.');
      }
      return okay;
    }

    _save(UserData userData) async {
      FocusScope.of(context).unfocus();
      setState(() {
        _autoValidate = true;
      });
      if (_formKey.currentState.validate()) {
        if (!_checkPin()) {
          return;
        }
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
          _setError(result.errorText);
          return;
        }
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/user-data-form');
      } else {
        _scrollToTop();
      }
    }

    _back() {
      Navigator.of(context).popAndPushNamed('/user-data-form');
    }

    Future<CloseForm> _showDiscardChangesDialog() async {
      return await DiscardChangesDialogUtil.showDiscardChangesDialog(context);
    }

    Future<bool> _onWillPop(UserData userData) async {
      UserData newUserData = _getNewUserData(userData);
      if (userData == newUserData) {
        _back();
      } else {
        CloseForm ret = await _showDiscardChangesDialog();
        if (ret == CloseForm.YES) {
          _back();
        }
      }
      return false;
    }

    Color getCircleColor(UserData userData) {
      if (_accountColor != null) {
        return _accountColor;
      }
      _accountColor = userData.accountColor == null ? Colors.amber : Color(userData.accountColor);
      return _accountColor;
    }

    Widget _editButton(Function onPress) {
      return SizedBox(
        width: 37.5,
        height: 37.5,
        child: FloatingActionButton(
          onPressed: () async {
            onPress();
          },
          child: Icon(Icons.edit),
          backgroundColor: Colors.grey,
          mini: true,
        ),
      );
    }

    List<DropdownMenuItem> _createGroupItems() {
      List<DropdownMenuItem> items = [];
      groups.forEach((Group group) {
        DropdownMenuItem item = DropdownMenuItem(value: group.name, child: Text(group.name));
        items.add(item);
      });
      return items;
    }

    Widget _createGroup(UserData userData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Trainingsgruppe', style: heading2TextStyle, textAlign: TextAlign.left),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: DropdownButtonFormField(
                    value: userData.groupName,
                    decoration: textInputDecoration.copyWith(labelText: 'Gruppenname'),
                    items: _createGroupItems(),
                    onChanged: (val) {
                      setState(() {
                        _groupName = val;
                        _pinVisibility = _isGroupPinRequired(userData);
                      });
                    },
                    validator: (val) {
                      return val == null ? 'Bitte wähle eine Traingsgruppe aus.' : null;
                    }),
              ),
              IconButton(
                  icon: Icon(Icons.group_add),
                  onPressed: () async {
                    dynamic newGroupName = await Navigator.pushNamed(context, '/add-group-form');
                    setState(() {
                      if (newGroupName != null) {
                        _coachGroupName = newGroupName;
                        _groupName = _coachGroupName;
                      }
                    });
                  }),
            ],
          ),
          SizedBox(height: 10),
          Visibility(
            visible: _pinVisibility,
            child: Container(
              width: 175,
              child: TextFormField(
                  onChanged: (String val) {
                    setState(() {
                      _groupPin = val;
                      if (_groupPin.length > 4) {
                        _groupPin = _groupPin.substring(0, 3);
                      }
                    });
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                  textInputAction: TextInputAction.next,
                  decoration: textInputDecoration.copyWith(labelText: 'Gruppen-PIN'),
                  validator: (String val) {
                    return val.isEmpty || val.length < 4 ? 'Bitte gib eine PIN\nmit vier Ziffern ein.' : null;
                  }),
            ),
          ),
        ],
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
                      bottom: 0,
                      right: 0,
                      child: _editButton(() async {
                        Color pickerColor = await ColorPickerDialogUtil.showColorPickerDialog(context, _accountColor);
                        setState(() {
                          _accountColor = pickerColor;
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

    return StreamBuilder<List<Group>>(
        stream: DatabaseService(uid: user.uid).groups,
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            if (snapshot.hasData) {
              groups = snapshot.data;
              return WillPopScope(
                onWillPop: () async {
                  return await _onWillPop(widget.userData);
                },
                child: Scaffold(
                    appBar: AppBar(title: Text('Profil berabeiten'), elevation: 0, actions: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          await _save(widget.userData);
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildErrorBox(),
                            ),
                            _createHeader(widget.userData),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      initialValue: widget.userData.firstName,
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
                                      initialValue: widget.userData.lastName,
                                      decoration: textInputDecoration.copyWith(labelText: 'Nachname'),
                                      keyboardType: TextInputType.text,
                                      onSaved: (String val) {
                                        setState(() {
                                          _lastName = val.trim();
                                        });
                                      },
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 100,
                                      child: TextFormField(
                                        initialValue: widget.userData.initials,
                                        decoration: textInputDecoration.copyWith(labelText: 'Initialien'),
                                        keyboardType: TextInputType.text,
                                        maxLength: 2,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(2),
                                        ],
                                        onSaved: (String val) {
                                          setState(() {
                                            _initials = val.trim();
                                            if (_initials.length > 2) {
                                              _initials = _initials.substring(0, 1);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(thickness: 1.25, height: 35),
                                    _createGroup(widget.userData)
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
          } else {
            return FillScreenErrorWidget(title: null, message: 'Daten der Gruppen können nicht gelesen werden');
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
