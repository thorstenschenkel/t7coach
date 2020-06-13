class Group {
  String name;
  String pin;
  String uid;

  @override
  bool operator ==(other) {
    if (other is Group) {
      return uid == other.uid && name == other.name && pin == other.pin;
    } else {
      return false;
    }
  }
}
