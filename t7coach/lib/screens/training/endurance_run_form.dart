import 'package:flutter/material.dart';
import 'package:t7coach/screens/training/training_session_widget.dart';

class EnduranceRunFrom extends StatefulWidget implements TrainingSessionWidget {

  _EnduranceRunFromState state;

  @override
  _EnduranceRunFromState createState() {
    state = _EnduranceRunFromState();
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
        state.addRun();
      },
      tooltip: 'Lauf',
      heroTag: 'run',
      child: Icon(Icons.directions_run),
    ));
    return buttons;
  }
}

class _EnduranceRunFromState extends State<EnduranceRunFrom> {
  List<Widget> detailsWidgets = [Text('EnduranceRun')];

  Widget addRun() {
    setState(() {
      detailsWidgets.add( Text('RUN') );
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
