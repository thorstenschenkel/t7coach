import 'dart:async';

import 'package:flutter/material.dart';
import 'package:t7coach/screens/training/details/speed_run_form.dart';
import 'details/note_form.dart';
import 'file:///C:/develop/flutterApps/t7coach/t7coach/lib/screens/training/details/rest_form.dart';
import 'package:t7coach/screens/training/training_session_widget.dart';

class SpeedRunsForm extends StatefulWidget with TrainingSessionWidget {
  _SpeedRunsFormState state;

  final Function scrollToEnd;

  SpeedRunsForm({this.scrollToEnd});

  @override
  _SpeedRunsFormState createState() {
    state = _SpeedRunsFormState();
    return state;
  }

  @override
  List<Widget> getFloatingActionButtonSubMenu() {
    List<Widget> buttons = super.getFloatingActionButtonSubMenu();
    buttons.add(FloatingActionButton(
      onPressed: () {
        state.addNote();
      },
      tooltip: 'Anmerkung',
      heroTag: 'note',
      child: Icon(Icons.speaker_notes),
    ));
    buttons.add(FloatingActionButton(
      onPressed: () {
        state.addRest();
      },
      tooltip: 'Pause',
      heroTag: 'rest',
      child: Icon(Icons.free_breakfast),
    ));
    buttons.add(FloatingActionButton(
      onPressed: () {
        state.addRun();
      },
      tooltip: 'Tempolauf',
      heroTag: 'run',
      child: Icon(Icons.directions_run),
    ));
    return buttons;
  }
}

class _SpeedRunsFormState extends State<SpeedRunsForm> {
  List<Widget> detailsWidgets = [];

  addDetail(Widget details) {
    setState(() {
      detailsWidgets.add(details);
    });
    Timer(Duration(milliseconds: 20), () => widget.scrollToEnd());
  }

  void addRun() {
    widget.createAddBottomSheet(context, SpeedRunForm(addDetail));
  }

  void addRest() {
    widget.createAddBottomSheet(context, RestForm(addDetail));
  }

  void addNote() {
    widget.createAddBottomSheet(context, NoteForm(addDetail));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: detailsWidgets,
    );
  }
}
