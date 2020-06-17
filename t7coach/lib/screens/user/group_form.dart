import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/db_error.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/input_constants.dart';
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
        // https://api.flutter.dev/flutter/material/Chip-class.html
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

  void _updateCoachName(User user, Group group) {
    DatabaseService(uid: user.uid).getCoachByCoachGroupName(group.name).then((result) {
      if (result is DbError) {
        print(result);
        print('TODO');
      } else if (result is UserData && result.isCoach()) {
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
        print('TODO');
      }
    }).catchError((e) {
      print('TODO');
    });
  }

  void _updateAthletes(User user, Group group) {
    DatabaseService(uid: user.uid).getUserDataByGroupName(group.name).then((result) {
      if (result is DbError) {
        print(result);
        print('TODO 1 - _updateAthletes');
      } else if (result is List<UserData>) {
        if (!listEquals(result, athletes)) {
          setState(() {
            athletes = result;
          });
        }
      } else {
        print('TODO 2 - _updateAthletes');
        print(result);
      }
    }).catchError((e) {
      print('TODO 3 - _updateAthletes');
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
              return Scaffold(
                  appBar: AppBar(title: Text('Traingsgruppe'), elevation: 0, actions: [
                    Visibility(
                      visible: widget.userData.isCoach(),
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
                      ])));
            } else {
              return Loading();
            }
          } else {
            return FillScreenErrorWidget(title: null, message: 'Daten der Gruppen können nicht gelesen werden');
          }
        });
  }
}
