class UserData {
  final String uid;
  String groupeId;
  String firstName = '';
  String lastName = '';
  String initials = '';

  // Color accountColor = Colors.amber;
  // int groupePin = 0;

  UserData({this.uid});

  @override
  bool operator ==(other) {
    if (other is UserData) {
      return uid == other.uid &&
          groupeId == other.groupeId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          initials == other.initials;
    } else {
      return false;
    }
  }
}
