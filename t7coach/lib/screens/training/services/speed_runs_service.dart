import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:t7coach/screens/training/details/note_form.dart';
import 'package:t7coach/screens/training/details/rest_form.dart';
import 'package:t7coach/screens/training/details/speed_run_form.dart';
import 'package:t7coach/screens/training/services/training_session_service.dart';

class SpeedRunsService extends TrainingSessionService {
  List<SpeedDialChild> getSpeedDialChildren(
      BuildContext context, Function createAddBottomSheetCallback, Function addDetailCallback) {
    return [
      SpeedDialChild(
        child: Icon(Icons.directions_run),
        backgroundColor: Theme.of(context).primaryColor,
        onTap: () {
          createAddBottomSheetCallback(SpeedRunForm(addDetailCallback, null));
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.free_breakfast),
        backgroundColor: Theme.of(context).primaryColor,
        onTap: () {
          createAddBottomSheetCallback(RestForm(addDetailCallback, null));
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
