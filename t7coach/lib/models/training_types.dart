// https://www.drsl.de/wiki/index.php?wasist=Englische_Laufterminologie&historie=ver

enum TrainingType { SPEED_RUNS, ENDURANCE_RUN }

const Map TrainingTypeMap = {TrainingType.SPEED_RUNS: 'Tempoläufe', TrainingType.ENDURANCE_RUN: 'Dauerlauf'};

enum RestType { JOG, WALK, JOG_WALK }

const Map RestTypeMap = {RestType.JOG: 'Trabpause', RestType.WALK: 'Gehpause', RestType.JOG_WALK: 'Trab-/Gehpause'};

enum DurationType { METERS, MINUTES }

const Map DurationTypeMap = {DurationType.METERS: 'Meter', DurationType.MINUTES: 'Minuten'};

class SpeedRun {
  String distance;
}

class Rest {
  RestType restType;
  DurationType durationType;
  String duration;
}

abstract class TrainingSession {
  DateTime date;
  TrainingType type;
  String note;
  String level;

  TrainingSession(DateTime date, TrainingType type) {
    this.date = date;
    this.type = type;
  }
}

class SpeedRuns extends TrainingSession {
  List<SpeedRun> runs = [];
  List<Rest> rests = [];

  SpeedRuns(DateTime date, TrainingType type) : super(date, type);
}
