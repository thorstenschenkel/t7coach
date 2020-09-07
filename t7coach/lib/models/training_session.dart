import 'package:t7coach/models/training_types.dart';

class TrainingSession {
  String uuid;

  String uid; // ID of the user who created this session
  String groupName;

  DateTime date;
  String level;
  TrainingType type;

  List<Detail> details;

  String convertDate2String() {
    return date.toString();
  }

  void convertString2Date(String dateStrg) {
    date = DateTime.parse(dateStrg);
  }

  String convertTrainingType2String() {
    return TrainingTypeMap[type];
  }

  void convertString2TrainingType(String typeStrg) {
    type = getTrainingTypeByString(typeStrg);
  }
}
