import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/training_types.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:t7coach/screens/authenticate/auth_form_constants.dart';
import 'package:t7coach/screens/training/details/rest_form.dart';
import 'package:t7coach/screens/training/details/run_form.dart';
import 'package:t7coach/screens/training/details/speed_run_detail.dart';
import 'package:t7coach/screens/training/details/speed_run_form.dart';
import 'package:t7coach/screens/training/services/endurance_run_service.dart';
import 'package:t7coach/screens/training/services/speed_runs_service.dart';
import 'package:t7coach/screens/training/services/training_session_service.dart';
import 'package:t7coach/services/datadase_service.dart';
import 'package:t7coach/shared/input_constants.dart';
import 'package:t7coach/shared/widgets/error_box_widget.dart';
import 'package:t7coach/shared/widgets/full_screen_error_widget.dart';
import 'package:t7coach/shared/widgets/loading.dart';

import 'details/note_detail.dart';
import 'details/note_form.dart';
import 'details/rest_detail.dart';
import 'details/run_detail.dart';
import 'details/single_detail.dart';

class TrainingCreateForm extends StatefulWidget {
  final UserData userData;

  TrainingCreateForm(this.userData);

  @override
  _TrainingCreateFormState createState() => _TrainingCreateFormState();
}

class _TrainingCreateFormState extends State<TrainingCreateForm> {
  final _scrollController = ScrollController();
  List<SingleDetail> details = [];
  TrainingSessionService _sessionService;
  bool _dialVisible = false;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _visibilityError = false;
  String error = '';
  List<Group> groups;
  Group group;
  TextEditingController _dateController = new TextEditingController(text: ' ');
  List<SpeedDialChild> speedDialChildren = [];

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
      final DropdownMenuItem item = DropdownMenuItem(value: type, child: Text(name));
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

  @override
  Widget build(BuildContext context) {
    void createAddBottomSheetCallback(Widget form) {
      showModalBottomSheet(
          isScrollControlled: true,
          enableDrag: true,
          isDismissible: true,
          context: context,
          builder: (context) {
            return Container(padding: EdgeInsets.fromLTRB(8, 40, 16, 8), child: form);
          });
    }

    void scrollToBottom() {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.linear, duration: const Duration(milliseconds: 1));
    }

    void addDetailCallback(SingleDetail detail) {
      setState(() {
        details.add(detail);
        scrollToBottom();
      });
    }

    void deleteDetailCallback(String uuid) {
      setState(() {
        details.removeWhere((single) {
          if (single.detail?.uuid == uuid) {
            return true;
          }
          return false;
        });
        scrollToBottom();
      });
    }

    void updateDetailCallback(SingleDetail detail) {
      SingleDetail oldSingleDetail;
      try {
        oldSingleDetail = details.firstWhere((single) {
          if (single.detail?.uuid == detail.detail.uuid) {
            return true;
          }
          return false;
        });
      } on StateError {}

      if (oldSingleDetail != null) {
        setState(() {
          oldSingleDetail.detail = detail.detail;
        });
      }
    }

    void editDetailCallback(SingleDetail singleDetail) {
      Widget formWidget;
      if (singleDetail is NoteDetail) {
        formWidget = NoteForm(updateDetailCallback, singleDetail.note);
      } else if (singleDetail is RestDetail) {
        formWidget = RestForm(updateDetailCallback, singleDetail.rest);
      } else if (singleDetail is RunDetail) {
        formWidget = RunForm(updateDetailCallback, singleDetail.run);
      } else if (singleDetail is SpeedRunDetail) {
        formWidget = SpeedRunForm(updateDetailCallback, singleDetail.run);
      }

      if (formWidget != null) {
        createAddBottomSheetCallback(formWidget);
      }
    }

    final user = Provider.of<User>(context);

    Future<bool> _onWillPop(UserData userData) async {
      return true;
    }

    void _updateTraining() {
      _sessionService = null;
      if (_trainingType != null) {
        switch (_trainingType) {
          case TrainingType.SPEED_RUNS:
            _sessionService = SpeedRunsService();
            break;
          case TrainingType.ENDURANCE_RUN:
            _sessionService = EnduranceRunService();
            break;
          default:
            print('unsupported trainings type: $_trainingType');
            break;
        }
      }
      setState(() {
        details.clear();
        if (_sessionService != null) {
          speedDialChildren =
              _sessionService.getSpeedDialChildren(context, createAddBottomSheetCallback, addDetailCallback);
        } else {
          speedDialChildren.clear();
        }
        _dialVisible = speedDialChildren.length > 0 ? true : false;
      });
    }

    Widget createTopForm() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                decoration: textInputDecoration.copyWith(labelText: 'Datum', suffixIcon: Icon(Icons.calendar_today)),
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
                      final _dateString = DateFormat('dd.MM.yyyy').format(pickedDate);
                      print(_dateString);
                      _dateController.value = TextEditingValue(text: _dateString);
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
          ],
        ),
      );
    }

    BottomAppBar createBottom() {
      // https://proandroiddev.com/flutter-how-to-using-bottomappbar-75d53426f5af

      return BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
      );
    }

    Widget createSpeedDial() {
      return SpeedDial(
          marginRight: 8,
          marginBottom: 32,
          animatedIcon: AnimatedIcons.menu_close,
          visible: _dialVisible,
          curve: Curves.bounceIn,
          children: speedDialChildren);
    }

    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final SingleDetail item = details.removeAt(oldIndex);
        details.insert(newIndex, item);
      });
    }

    Widget secondaryStackBehindDismiss() {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 8),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      );
    }

    Widget stackBehindDismiss() {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 8),
        color: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      );
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
                    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                    floatingActionButton: createSpeedDial(),
                    bottomNavigationBar: createBottom(),
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
                        child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(children: <Widget>[
                              createTopForm(),
                              new Expanded(
                                child: ReorderableListView(
                                    children: details.map((detail) {
                                      return Dismissible(
                                        key: ObjectKey(detail.detail.uuid),
                                        background: stackBehindDismiss(),
                                        secondaryBackground: secondaryStackBehindDismiss(),
                                        direction: DismissDirection.horizontal,
                                        confirmDismiss: (direction) async {
                                          if (direction == DismissDirection.endToStart) {
                                            return true;
                                          } else if (direction == DismissDirection.startToEnd) {
                                            editDetailCallback(detail);
                                          }
                                          return false;
                                        },
                                        onDismissed: (direction) {
                                          if (direction == DismissDirection.endToStart) {
                                            deleteDetailCallback(detail.detail.uuid);
                                          }
                                        },
                                        child: Card(
                                          child: detail.createTile(context),
                                          key: ObjectKey(detail.detail.uuid),
                                        ),
                                      );
                                    }).toList(),
                                    onReorder: _onReorder,
                                    scrollController: _scrollController),
                              )
                            ])))),
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
