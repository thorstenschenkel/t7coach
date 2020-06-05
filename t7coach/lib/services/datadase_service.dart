import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:t7coach/models/db_error.dart';
import 'package:t7coach/models/user_data.dart';

class DatabaseService {
  final String uid;
  static const errorTexts = {};

  DatabaseService({this.uid});

  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Future updateUserData(UserData userData) async {
    try {
      final Map<String, dynamic> data = {
        'groupeId': userData.groupeId,
        'firstName': userData.firstName,
        'lastName': userData.lastName,
        'initials': userData.initials,
        'accountColor': userData.accountColor
      };
      return await usersCollection.document(uid).setData(data).timeout(Duration(seconds: 20));
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Speichern');
    }
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    UserData userData = UserData(uid: uid);
    userData.groupeId = snapshot.data['groupeId'];
    userData.firstName = snapshot.data['firstName'];
    userData.lastName = snapshot.data['lastName'];
    userData.initials = snapshot.data['initials'];
    userData.accountColor = snapshot.data['accountColor'];
    return userData;
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  DbError _exceptionToError(exception, String defaultText) {
    String errorText = defaultText;
    if (exception is PlatformException) {
      if (errorTexts.containsKey(exception.code)) {
        errorText = errorTexts[exception.code];
      }
    }
    return DbError(errorText: errorText);
  }
}
