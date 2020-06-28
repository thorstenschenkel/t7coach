import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/training/endurance_run_form.dart';
import 'package:t7coach/screens/training/speed_runs_form.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/animated_floatactionbuttons.dart';
import 'package:t7coach/shared/widgets/error_box_widget.dart';
import 'package:t7coach/shared/widgets/full_screen_error_widget.dart';
import 'package:t7coach/shared/widgets/loading.dart';

class TrainingAddForm extends StatefulWidget {
  final UserData userData;

  TrainingAddForm(@required this.userData);

  @override
  _TrainingAddFormState createState() => _TrainingAddFormState();
}

class _TrainingAddFormState extends State<TrainingAddForm> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController _dateController = new TextEditingController(text: ' ');
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _visibilityError = false;
  String error = '';
  List<Group> groups;
  Group group;
  List<Widget> trainingWidgets = [];
  List<Widget> fbaSubButtons = [];

  // form values
  String _dateString;
  TrainingType _trainingType;
  String _level;

  Widget buildErrorBox() {
    return Visibility(visible: _visibilityError, child: ErrorBoxWidget(error));
  }

  _save() {
    // TODO
  }

  List<DropdownMenuItem> _createTraingTypeItems() {
    List<DropdownMenuItem> items = [];
    TrainingTypeMap.forEach((type, name) {
      DropdownMenuItem item = DropdownMenuItem(value: type, child: Text(name));
      items.add(item);
    });
    return items;
  }

  List<DropdownMenuItem> _createLevelItems(Group group) {
    List<DropdownMenuItem> items = [];
    group.levels.forEach((name) {
      DropdownMenuItem item = DropdownMenuItem(value: name, child: Text(name));
      items.add(item);
    });
    return items;
  }

  _updateTraining() {
    trainingWidgets.clear();
    if (_trainingType != null) {
      switch (_trainingType) {
        case TrainingType.SPEED_RUNS:
          SpeedRunsForm widget = SpeedRunsForm();
          trainingWidgets.add(widget);
          setState(() {
            fbaSubButtons = widget.getFloatingActionButtonSubMenu();
          });
          break;
        case TrainingType.ENDURANCE_RUN:
          EnduranceRunFrom widget = EnduranceRunFrom();
          trainingWidgets.add(widget);
          setState(() {
            fbaSubButtons = widget.getFloatingActionButtonSubMenu();
          });
          break;
        default:
          print('unsupported trainings type: $_trainingType');
          setState(() {
            fbaSubButtons.clear();
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _dateController.text = _dateString;

    Future<bool> _onWillPop(UserData userData) async {
      return true;
    }

    return StreamBuilder<List<Group>>(
        stream: DatabaseService(uid: user.uid).groups,
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            if (snapshot.hasData) {
              groups = snapshot.data;
              group = groups.firstWhere((g) => g.name == widget.userData.groupName);
              return WillPopScope(
                  onWillPop: () async {
                    return await _onWillPop(widget.userData);
                  },
                  child: Scaffold(
                    appBar: AppBar(title: Text('Neue Trainingseinheit'), elevation: 0, actions: [
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                  key: _formKey,
                                  autovalidate: _autoValidate,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          buildErrorBox(),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 175,
                                      child: TextFormField(
                                        controller: _dateController,
                                        decoration: textInputDecoration.copyWith(
                                            labelText: 'Datum', suffixIcon: Icon(Icons.calendar_today)),
                                        readOnly: true,
                                        onTap: () async {
                                          // TODO
                                          // - DatePickerEntryMode.input
                                          // - Title: Select Date
                                          DateTime pickedDate = await showDatePicker(
                                              context: context,
                                              locale: Locale("de", "DE"),
                                              fieldLabelText: 'Datum',
                                              confirmText: 'OK',
                                              cancelText: 'Abbrechen',
                                              initialDatePickerMode: DatePickerMode.day,
                                              initialEntryMode: DatePickerEntryMode.calendar,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100));
                                          if (pickedDate != null) {
                                            setState(() {
                                              _dateString = DateFormat('dd.MM.yyyy').format(pickedDate);
                                              print(_dateString);
                                            });
                                          }
                                        },
                                        validator: (val) {
                                          return val == null ? 'Bitte wähle ein Datum aus.' : null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Visibility(
                                        visible: group.levels.length > 0,
                                        child: Column(
                                          children: <Widget>[
                                            DropdownButtonFormField(
                                                decoration: textInputDecoration.copyWith(labelText: 'Leistungslevels'),
                                                items: _createLevelItems(group),
                                                onChanged: (val) {
                                                  setState(() {
                                                    _level = val;
                                                  });
                                                },
                                                validator: (val) {
                                                  return val == null ? 'Bitte wähle einen Leistungslevels aus.' : null;
                                                }),
                                            SizedBox(height: 10),
                                          ],
                                        )),
                                    DropdownButtonFormField(
                                        decoration: textInputDecoration.copyWith(labelText: 'Trainingsart'),
                                        items: _createTraingTypeItems(),
                                        onChanged: (val) {
                                          setState(() {
                                            _trainingType = val;
                                            _updateTraining();
                                          });
                                        },
                                        validator: (val) {
                                          return val == null ? 'Bitte wähle eine Trainingsart aus.' : null;
                                        }),
                                    divider,
                                    Column(
                                      children: trainingWidgets,
                                    )
                                  ])),
                            ))),
                    floatingActionButton: Visibility(
                      visible: fbaSubButtons.length > 0,
                      child: AnimatedFloatingActionButton(
                          fabButtons: fbaSubButtons,
                          colorStartAnimation: Colors.blue,
                          colorEndAnimation: Colors.red,
                          animatedIconData: AnimatedIcons.menu_close,
                          tooltip: 'Hinzufügen'
                      ),
                    ),
                  ));
            } else {
              return Loading();
            }
          } else {
            return FillScreenErrorWidget(title: null, message: 'Daten der Gruppen können nicht gelesen werden');
          }
        });
  }
}
