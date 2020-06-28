import 'package:flutter/material.dart';
import 'package:t7coach/screens/training/training_session_widget.dart';

class SpeedRunsForm extends StatefulWidget implements TrainingSessionWidget {

  _SpeedRunsFormState state;

  @override
  _SpeedRunsFormState createState() {
    state = _SpeedRunsFormState();
    return state;
  }

  @override
  List<Widget> getFloatingActionButtonSubMenu() {
    List<Widget> buttons = [];
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
  List<Widget> detailsWidgets = [Text('SpeedRuns')];

  Widget addRun() {
    setState(() {
      detailsWidgets.add( Text('RUN') );
    });
  }

  Widget addRest() {
    setState(() {
      detailsWidgets.add( Text('REST') );
    });
  }

  Widget addNote() {
    setState(() {
      detailsWidgets.add( Text('NOTE') );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: detailsWidgets,
    );
  }
}
