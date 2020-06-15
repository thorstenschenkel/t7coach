import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/db_error.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/user/level_form.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/dialogs/discard_changes_dialog_util.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/error_box_widget.dart';

class AddGroupForm extends StatefulWidget {
  @override
  _AddGroupFormState createState() => _AddGroupFormState();
}

class _AddGroupFormState extends State<AddGroupForm> {
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _autoValidate = false;
  bool _visibilityError = false;
  String error = '';

  String _name = '';
  String _pin = '';
  List<String> _levels = [];

  Widget buildErrorBox() {
    return Visibility(visible: _visibilityError, child: ErrorBoxWidget(error));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _scrollToTop() {
      _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInSine);
    }

    Group _getNewGroup() {
      _formKey.currentState.save();
      Group newGroup = Group();
      newGroup.name = (_name ?? '').trim();
      newGroup.pin = (_pin ?? '').trim();
      newGroup.levels = _levels;
      return newGroup;
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

    _save() async {
      FocusScope.of(context).unfocus();
      setState(() {
        _autoValidate = true;
        error = '';
        _visibilityError = false;
      });
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        Group newGroup = _getNewGroup();
        dynamic getResult = await DatabaseService(uid: user.uid).getGroupsByName(newGroup.name);
        if (getResult is DbError) {
          _setError(getResult.errorText);
          return;
        }
        if (getResult is List) {
          if (getResult.length > 0) {
            _setError('Eine Gruppe mit diesem Namen existiert bereits.');
            return;
          }
        }
        dynamic updateResult = await DatabaseService(uid: user.uid).updateGroup(newGroup);
        if (updateResult is DbError) {
          _setError(updateResult.errorText);
          return;
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(newGroup.name);
      } else {
        _scrollToTop();
      }
    }

    Future<CloseForm> _showDiscardChangesDialog() async {
      return await DiscardChangesDialogUtil.showDiscardChangesDialog(context);
    }

    Future<bool> _onWillPop() async {
      _formKey.currentState.save();
      if (_name.length == 0 && _pin.length == 0 && _levels.length == 0) {
        return true;
      } else {
        CloseForm ret = await _showDiscardChangesDialog();
        if (ret == CloseForm.YES) {
          return true;
        }
      }
      return false;
    }

    void _addLevel(String level) {
      if (_levels.length < 7) {
        setState(() {
          _levels.add(level);
        });
      }
    }

    List<Widget> _getLevelChips() {
      List<Widget> chips = [];
      _levels.forEach((level) {
        Color color = Colors.primaries[chips.length * 2];
        Color textColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
        Chip chip = Chip(
          label: Text(level, style: TextStyle(color: textColor)),
          backgroundColor: color,
          deleteIcon: Icon(Icons.cancel),
          deleteIconColor: Colors.grey[200],
          onDeleted: () {
            setState(() {
              _levels.remove(level);
            });
          },
        );
        chips.add(chip);
      });
      return chips;
    }

    void _showSettingsPanel() {
      showModalBottomSheet(
          isScrollControlled: false,
          enableDrag: true,
          isDismissible: true,
          context: context,
          builder: (context) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child: LevelFrom(_levels, _addLevel));
          });
    }

    return WillPopScope(
      onWillPop: () async {
        return await _onWillPop();
      },
      child: Scaffold(
          key: _globalKey,
          appBar: AppBar(title: Text('Neue Traingsgruppe'), elevation: 0, actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _save();
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
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildErrorBox(),
                          TextFormField(
                              onSaved: (String val) {
                                setState(() {
                                  _name = val;
                                });
                              },
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: textInputDecoration.copyWith(labelText: 'Gruppenname'),
                              validator: (String val) =>
                                  val.isEmpty ? 'Bitte gib einen Namen für die Traingsgruppe ein.' : null),
                          SizedBox(height: 10),
                          Container(
                            width: 175,
                            child: TextFormField(
                                onSaved: (String val) {
                                  setState(() {
                                    _pin = val;
                                    if (_pin.length > 4) {
                                      _pin = _pin.substring(0, 3);
                                    }
                                  });
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4)
                                ],
                                textInputAction: TextInputAction.next,
                                decoration: textInputDecoration.copyWith(labelText: 'Gruppen-PIN'),
                                validator: (String val) {
                                  print(val);
                                  return val.isEmpty || val.length < 4
                                      ? 'Bitte gib eine PIN\nmit vier Ziffern ein.'
                                      : null;
                                }),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text('Leistungslevels', style: heading2TextStyle, textAlign: TextAlign.left),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (_levels.length >= 7) {
                                      _globalKey.currentState.showSnackBar(SnackBar(
                                        content: Text('Du kannst maximal 7 Levels anlegen.'),
                                      ));
                                    } else {
                                      _showSettingsPanel();
                                    }
                                  }),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _getLevelChips(),
                          )
//                        SizedBox(height: 5),
//                        RaisedButton(
//                            onPressed: () async {
//                              await _save();
//                            },
//                            child: Text('Speichern')),
                        ],
                      ),
                    ),
                  )))),
    );
  }
}
