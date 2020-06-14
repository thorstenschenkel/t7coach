import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/full_screen_error_widget.dart';
import 'package:t7coach/shared/widgets/loading.dart';

class GroupForm extends StatelessWidget {
  final UserData userData;
  List<Group> groups;
  Group group;

  GroupForm(@required this.userData) {}

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<Group>>(
        stream: DatabaseService(uid: user.uid).groups,
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            if (snapshot.hasData) {
              groups = snapshot.data;
              group = groups.firstWhere((g) => g.name == userData.groupName);
              return Scaffold(
                  appBar: AppBar(title: Text('Traingsgruppe'), elevation: 0, actions: [
                    Visibility(
                      visible: userData.isCoach(),
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
                                initialValue: userData.groupName,
                                decoration: _getTextInputDecoration(context, 'Gruppenname'),
                                readOnly: true),
                            SizedBox(height: 5),
                            Text('Leistungslevels', style: heading2TextStyle, textAlign: TextAlign.left),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: _getLevelChips(),
                            )
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
