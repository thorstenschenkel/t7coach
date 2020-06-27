class UserData {
  final String uid;
  String firstName = '';
  String lastName = '';
  String initials = '';
  int accountColor;
  String groupName;

  UserData({this.uid});

  @override
  bool operator ==(other) {
    if (other is UserData) {
      return uid == other.uid &&
          groupName == other.groupName &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          initials == other.initials &&
          accountColor == other.accountColor;
    } else {
      return false;
    }
  }

  String getFullName() {
    String name = this.firstName ?? '';
    name += name.length > 0 && this.lastName.length > 0 ? ' ' : '';
    name += this.lastName;
    return name;
  }

  bool isFullNameEmpty() {
    String name = this.getFullName();
    return name == null || name.isEmpty;
  }

  String getFirstOrLastname() {
    if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    } else {
      return lastName;
    }
  }
}
