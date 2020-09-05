// https://www.drsl.de/wiki/index.php?wasist=Englische_Laufterminologie&historie=ver

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum TrainingType { SPEED_RUNS, ENDURANCE_RUN }

const Map TrainingTypeMap = {TrainingType.SPEED_RUNS: 'Tempoläufe', TrainingType.ENDURANCE_RUN: 'Dauerlauf'};

TrainingType getTrainingTypeByString(String strg) {
  TrainingType retKey = null;
  TrainingTypeMap.forEach((key, value) {
    if (strg == value) {
      retKey = key;
    }
  });
  return retKey;
}

enum RestType { JOG, WALK, JOG_WALK }

const Map RestTypeMap = {RestType.JOG: 'Trabpause', RestType.WALK: 'Gehpause', RestType.JOG_WALK: 'Trab-/Gehpause'};

RestType getRestTypeByString(String strg) {
  RestType retKey = null;
  RestTypeMap.forEach((key, value) {
    if (strg == value) {
      retKey = key;
    }
  });
  return retKey;
}

enum DurationType { METRES, KILOMETRES, MINUTES, HOUERS }

const Map DurationTypeMap = {
  DurationType.METRES: 'Meter',
  DurationType.KILOMETRES: 'Kilometer',
  DurationType.MINUTES: 'Minuten',
  DurationType.HOUERS: 'Stunden'
};

DurationType getDurationTypeByString(String strg) {
  DurationType retKey = null;
  DurationTypeMap.forEach((key, value) {
    if (strg == value) {
      retKey = key;
    }
  });
  return retKey;
}

enum RunType { SPEED_RUN, MEDIUM_TEMPO_RUN, EASY_RUN, LONG_SLOW_DISTANCE }

const Map RunTypeMap = {
  RunType.SPEED_RUN: 'Tempolauf',
  RunType.MEDIUM_TEMPO_RUN: 'Lockerer Dauerlauf',
  RunType.EASY_RUN: 'Ruhiger Dauerlauf',
  RunType.LONG_SLOW_DISTANCE: 'Langsamer Dauerlauf'
};

RunType getRunTypeByString(String strg) {
  RunType retKey = null;
  RunTypeMap.forEach((key, value) {
    if (strg == value) {
      retKey = key;
    }
  });
  return retKey;
}

abstract class Detail {
  String uuid;

  Detail() {
    uuid = Uuid().v1();
  }

  String getText() {
    return '';
  }

  Icon getIcon() {
    return null;
  }
}

String getDurationText(DurationType durationType, String duration) {
  String text = '${duration.trim()}';
  text += ' ';
  switch (durationType) {
    case DurationType.METRES:
      text += 'm';
      break;
    case DurationType.KILOMETRES:
      text += 'km';
      break;
    case DurationType.MINUTES:
      text += 'min';
      break;
    case DurationType.HOUERS:
      text += 'h';
      break;
  }
  return text;
}

class Run extends Detail {
  RunType runType;
  DurationType durationType;
  String duration;

  Run(this.runType, this.durationType, this.duration);

  @override
  String getText() {
    String text = RunTypeMap.values.toList()[runType.index];
    text += ': ';
    text += getDurationText(durationType, duration);
    return text;
  }

  Run.fromJson(Map<String, dynamic> json)
      : runType = getRunTypeByString(json['runType']),
        durationType = getDurationTypeByString(json['durationType']),
        duration = json['duration'];

  Map<String, dynamic> toJson() =>
      {'runType': RunTypeMap[runType], 'durationType': DurationTypeMap[durationType], 'duration': duration};
}

class SpeedRun extends Detail {
  DurationType durationType;
  String duration;

  SpeedRun(this.durationType, this.duration);

  @override
  String getText() {
    String text = getDurationText(durationType, duration);
    return text;
  }

  SpeedRun.fromJson(Map<String, dynamic> json)
      : durationType = getDurationTypeByString(json['durationType']),
        duration = json['duration'];

  Map<String, dynamic> toJson() => {'durationType': DurationTypeMap[durationType], 'duration': duration};
}

class Rest extends Detail {
  RestType restType;
  DurationType durationType;
  String duration;

  Rest(this.restType, this.durationType, this.duration);

  @override
  String getText() {
    String text = RestTypeMap.values.toList()[restType.index];
    text += ': ';
    text += getDurationText(durationType, duration);
    return text;
  }

  Rest.fromJson(Map<String, dynamic> json)
      : restType = getRestTypeByString(json['name']),
        durationType = getDurationTypeByString(json['durationType']),
        duration = json['duration'];

  Map<String, dynamic> toJson() =>
      {'restType': RestTypeMap[restType], 'durationType': DurationTypeMap[durationType], 'duration': duration};
}

class Note extends Detail {
  String note;

  Note(this.note);

  @override
  String getText() {
    return note.trim();
  }

  Note.fromJson(Map<String, dynamic> json) : note = json['note'];

  Map<String, dynamic> toJson() => {'note': note};
}
