class UserData {
  final String uid;
  String groupId;
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
          groupId == other.groupId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          initials == other.initials &&
          accountColor == other.accountColor;
    } else {
      return false;
    }
  }
}
