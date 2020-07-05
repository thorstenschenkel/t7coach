import 'dart:async';

import 'package:flutter/material.dart';
import 'package:t7coach/screens/training/details/note_form.dart';
import 'package:t7coach/screens/training/training_session_widget.dart';

import 'details/run_form.dart';

class EnduranceRunFrom extends StatefulWidget with TrainingSessionWidget {
  _EnduranceRunFromState state;

  final Function scrollToEnd;

  EnduranceRunFrom({this.scrollToEnd});

  @override
  _EnduranceRunFromState createState() {
    state = _EnduranceRunFromState();
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
  List<Widget> detailsWidgets = [];

  addDetail(Widget details) {
    setState(() {
      detailsWidgets.add(details);
    });
    Timer(Duration(milliseconds: 20), () => widget.scrollToEnd());
  }

//  delete(String uuid) {
//    Widget toDelete = detailsWidgets.firstWhere((w) {
//      if (w is SingleForm) {
//        if ((w as SingleForm).getUuid() == uuid) {
//          return true;
//        }
//      }
//      return false;
//    });
//
//    if (toDelete != null) {
//      setState(() {
//        detailsWidgets.remove(toDelete);
//      });
//    }
//  }

  void addRun() {
    widget.createAddBottomSheet(context, RunForm(addDetail));
  }

  Widget addNote() {
    widget.createAddBottomSheet(context, NoteForm(addDetail));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: detailsWidgets,
    );
  }
}
