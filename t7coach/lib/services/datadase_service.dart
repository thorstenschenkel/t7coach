import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t7coach/models/user_data.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Future updateUserData(UserData userData) async {
    final Map<String, dynamic> data = {
      'groupeId': userData.groupeId,
      'firstName': userData.firstName,
      'lastName': userData.lastName,
      'initials': userData.initials
    };
    return await usersCollection.document(uid).setData(data);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    UserData userData = UserData(uid: uid);
    userData.groupeId = snapshot.data['groupeId'];
    userData.firstName = snapshot.data['firstName'];
    userData.lastName = snapshot.data['lastName'];
    userData.initials = snapshot.data['initials'];
    return userData;
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
