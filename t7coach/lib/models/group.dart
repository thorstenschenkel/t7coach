import 'package:flutter/foundation.dart';

class Group {
  String name;
  String pin;
  String uid;
  List<String> levels;

  @override
  bool operator ==(other) {
    if (other is Group) {
      return uid == other.uid && name == other.name && pin == other.pin && listEquals(levels, other.levels);
    } else {
      return false;
    }
  }
}
