import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/db_error.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/error_box_widget.dart';
import 'package:t7coach/shared/widgets/full_screen_error_widget.dart';
import 'package:t7coach/shared/widgets/loading.dart';
import 'package:t7coach/shared/widgets/user_chip.dart';

class GroupForm extends StatefulWidget {
  final UserData userData;

  GroupForm(@required this.userData) {}

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  bool _isLoading = true;
  bool _isLoadingAthletes = true;
  bool _isLoadingCoachName = true;
  bool _visibilityError = false;
  bool _updateCoachFailed = false;
  bool _updateAthletesFailed = false;
  String error;
  List<Group> groups;
  Group group;
  String coachName = 'TEST';
  List<UserData> athletes = [];
  TextEditingController _coachNameController = new TextEditingController(text: ' ');

  InputDecoration _getTextInputDecoration(BuildContext context, String label) {
    InputDecoration deco = textInputDecoration.copyWith(labelText: label);
    deco = deco.copyWith(
        hintText: ' ',
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        fillColor: Theme.of(context).colorScheme.background,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)));
    return deco;
  }

  Color getCircleColor(UserData userData) {
    return userData.accountColor == null ? Colors.amber : Color(userData.accountColor);
  }

  List<Widget> _getAthletesChips() {
    List<Widget> chips = [];
    if (athletes != null && athletes.isNotEmpty) {
      athletes.forEach((userData) {
        UserChip chip = UserChip(userData: userData);
        chips.add(chip);
      });
    }
    return chips;
  }

  List<Widget> _getLevelChips() {
    List<Widget> chips = [];
    if (group?.levels != null) {
      group.levels.forEach((level) {
        Color color = Colors.primaries[chips.length * 2];
        Color textColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
        Chip chip = Chip(label: Text(level, style: TextStyle(color: textColor)), backgroundColor: color);
        chips.add(chip);
      });
    }
    return chips;
  }

  bool _isCoach(User user, Group group) {
    return group.uid == user.uid;
  }

  void _updateCoachName(User user, Group group) {
    if (_updateCoachFailed) {
      return;
    }
    DatabaseService(uid: user.uid).getUserData().then((result) {
      if (result is DbError) {
        print(result.errorText);
        _setError(result.errorText);
        _updateAthletesFailed = true;
      } else if (result is UserData && _isCoach(user, group)) {
        String newCoachName = result.firstName ?? '';
        newCoachName += newCoachName.isNotEmpty ? ' ' : '';
        newCoachName += result.lastName ?? '';
        newCoachName = newCoachName.trim();
        if (newCoachName != coachName) {
          setState(() {
            coachName = newCoachName;
            _coachNameController.text = coachName;
          });
        }
      } else {
        print(result);
        _setError('Fehler beim Lesen des Namens des Trainers #0002');
        _updateCoachFailed = true;
      }
    }).catchError((e) {
      print(e);
      _setError('Fehler beim Lesen des Namens des Trainers #0003');
      _updateCoachFailed = true;
    }).whenComplete(() {
      _isLoadingCoachName = false;
      updateLoading();
    });
  }

  void _updateAthletes(User user, Group group) {
    if (_updateAthletesFailed) {
      return;
    }
    DatabaseService(uid: user.uid).getUserDataByGroupName(group.name).then((result) {
      if (result is DbError) {
        print(result.errorText);
        _setError(result.errorText);
        _updateAthletesFailed = true;
      } else if (result is List<UserData>) {
        if (!listEquals(result, athletes)) {
          setState(() {
            athletes = result;
          });
        }
      } else {
        print(result);
        _setError('Fehler beim Lesen der Athleten #0002');
        _updateAthletesFailed = true;
      }
    }).catchError((e) {
      print(e);
      _setError('Fehler beim Lesen der Athleten #0003');
      _updateAthletesFailed = true;
    }).whenComplete(() {
      _isLoadingAthletes = false;
      updateLoading();
    });
  }

  void updateLoading() {
    setState(() {
      _isLoading = _isLoadingAthletes || _isLoadingCoachName;
    });
  }

  Widget _buildErrorBox() {
    return Visibility(
      visible: _visibilityError,
      child: ErrorBoxWidget(error),
    );
  }

  void _setError(String text) {
    setState(() {
      error = text;
      _visibilityError = true;
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<Group>>(
        stream: DatabaseService(uid: user.uid).groups,
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            if (snapshot.hasData) {
              groups = snapshot.data;
              group = groups.firstWhere((g) => g.name == widget.userData.groupName);
              _updateCoachName(user, group);
              _updateAthletes(user, group);
              return LoadingOverlay(
                isLoading: _isLoading,
                opacity: 0.75,
                progressIndicator: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme
                      .of(context)
                      .colorScheme
                      .primary),
                ),
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                child: Scaffold(
                    appBar: AppBar(title: Text('Traingsgruppe'), elevation: 0, actions: [
                      Visibility(
                        visible: _isCoach(user, group),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ),
                    ]),
                    body: SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _buildErrorBox(),
                                  TextFormField(
                                      initialValue: widget.userData.groupName,
                                      decoration: _getTextInputDecoration(context, 'Gruppenname'),
                                      readOnly: true),
                                  SizedBox(height: 5),
                                  TextFormField(
                                      controller: _coachNameController,
                                      // initialValue: coachName,
                                      decoration: _getTextInputDecoration(context, 'Trainer'),
                                      readOnly: true),
                                  SizedBox(height: 5),
                                  Text('Athleten', style: heading2TextStyle, textAlign: TextAlign.left),
                                  Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: _getAthletesChips(),
                                  ),
                                  SizedBox(height: 5),
                                  Visibility(
                                      visible: group?.levels != null && group.levels.length > 0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Leistungslevels', style: heading2TextStyle, textAlign: TextAlign.left),
                                      Wrap(
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: _getLevelChips(),
                                      )
                                    ],
                                  ))
                                ],
                              ))
                        ]))),
              );
            } else {
              return Loading();
            }
          } else {
            return FillScreenErrorWidget(title: null, message: 'Daten der Gruppen können nicht gelesen werden');
          }
        });
  }
}
