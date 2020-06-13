class UserData {
  final String uid;
  String firstName = '';
  String lastName = '';
  String initials = '';
  int accountColor;
  String groupName;
  String coachGroupName;

  UserData({this.uid});

  @override
  bool operator ==(other) {
    if (other is UserData) {
      return uid == other.uid &&
          groupName == other.groupName &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          initials == other.initials &&
          accountColor == other.accountColor &&
          coachGroupName == other.coachGroupName;
    } else {
      return false;
    }
  }

  isCoach() {
    if ( groupName == null || groupName.isEmpty ) {
      return false;
    }
    if ( coachGroupName == null || coachGroupName.isEmpty ) {
      return false;
    }
    return groupName == coachGroupName;
  }
}
