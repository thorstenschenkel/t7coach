import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:t7coach/screens/training/details/note_form.dart';
import 'package:t7coach/screens/training/details/run_form.dart';
import 'package:t7coach/screens/training/services/training_session_service.dart';

class EnduranceRunService extends TrainingSessionService {
  List<SpeedDialChild> getSpeedDialChildren(
      BuildContext context, Function createAddBottomSheetCallback, Function addDetailCallback) {
    return [
      SpeedDialChild(
        child: Icon(Icons.directions_run),
        backgroundColor: Theme.of(context).primaryColor,
        onTap: () {
          createAddBottomSheetCallback(RunForm(addDetailCallback, null));
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.speaker_notes),
        backgroundColor: Theme.of(context).primaryColor,
        onTap: () {
          createAddBottomSheetCallback(NoteForm(addDetailCallback, null));
        },
      ),
    ];
  }
}
