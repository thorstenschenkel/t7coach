import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

abstract class TrainingSessionService {
  List<SpeedDialChild> getSpeedDialChildren(
      BuildContext context, Function createAddBottomSheetCallback, Function addDetailCallback);
}
