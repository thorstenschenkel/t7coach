class UserData {
  final String uid;
  String groupeId;
  String firstName = '';
  String lastName = '';
  String initials = '';
  int accountColor;

  // int groupePin = 0;

  UserData({this.uid});

  @override
  bool operator ==(other) {
    if (other is UserData) {
      return uid == other.uid &&
          groupeId == other.groupeId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          initials == other.initials &&
          accountColor == other.accountColor;
    } else {
      return false;
    }
  }
}
