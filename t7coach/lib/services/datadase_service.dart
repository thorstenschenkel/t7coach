import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:t7coach/models/db_error.dart';
import 'package:t7coach/models/group.dart';
import 'package:t7coach/models/training_session.dart';
import 'package:t7coach/models/user_data.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final String uid;
  static const errorTexts = {};

  DatabaseService({this.uid});

  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference groupsCollection = Firestore.instance.collection('groups');
  final CollectionReference trainingSessionsCollection = Firestore.instance.collection('training-sessions');

  // user data
  Future updateUserData(UserData userData) async {
    try {
      final Map<String, dynamic> data = {
        'groupName': userData.groupName,
        'firstName': userData.firstName,
        'lastName': userData.lastName,
        'initials': userData.initials,
        'accountColor': userData.accountColor,
      };
      return await usersCollection.document(uid).setData(data).timeout(Duration(seconds: 20));
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Speichern des Profils');
    }
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    UserData userData = UserData(uid: uid);
    if (snapshot.data != null) {
      userData.groupName = snapshot.data['groupName'];
      userData.firstName = snapshot.data['firstName'];
      userData.lastName = snapshot.data['lastName'];
      userData.initials = snapshot.data['initials'];
      userData.accountColor = snapshot.data['accountColor'];
    }
    return userData;
  }

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future getUserData() async {
    try {
      DocumentSnapshot snapshot = await usersCollection.document(uid).get();
      if (snapshot != null) {
        return _userDataFromSnapshot(snapshot);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Lesen des Trainers/Athleten');
    }
  }

  Future getUserDataByGroupName(String name) async {
    try {
      QuerySnapshot snapshot = await usersCollection.where('groupName', isEqualTo: name).getDocuments();
      List<UserData> athletes = [];
      snapshot.documents.forEach((DocumentSnapshot snapshot) {
        UserData userData = _userDataFromSnapshot(snapshot);
        athletes.add(userData);
      });
      return athletes;
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Lesen der Athleten');
    }
  }

  // groupe
  Future updateGroup(Group group) async {
    try {
      group.uid = group.uid ?? uid;
      final Map<String, dynamic> data = {
        'name': group.name,
        'pin': group.pin,
        'uid': group.uid,
        'levels': group.levels
      };
      return await groupsCollection.document().setData(data);
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Speichern der Trainingsgruppe');
    }
  }

  Group _groupFromSnapshot(DocumentSnapshot snapshot) {
    Group group = Group();
    if (snapshot.data != null) {
      group.name = snapshot.data['name'];
      group.pin = snapshot.data['pin'];
      group.uid = snapshot.data['uid'];
      if (snapshot.data['levels'] != null) {
        group.levels = List.castFrom<dynamic, String>(snapshot.data['levels']);
      } else {
        group.levels = [];
      }
    }
    return group;
  }

  Future getGroupsByName(String name) async {
    try {
      QuerySnapshot snapshot = await groupsCollection.where('name', isEqualTo: name).getDocuments();
      List<Group> groups = [];
      snapshot.documents.forEach((DocumentSnapshot snapshot) {
        Group group = _groupFromSnapshot(snapshot);
        groups.add(group);
      });
      return groups;
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Lesen der Trainingsgruppe');
    }
  }

  Stream<List<Group>> get groups {
    return groupsCollection.getDocuments().then((snapshot) {
      List<Group> groups = [];
      snapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
        Group group = _groupFromSnapshot(documentSnapshot);
        groups.add(group);
      });
      groups.sort((Group g1, Group g2) {
        return g1.name.toString().compareTo(g2.name.toString());
      });
      return groups;
    }).asStream();
  }

  Future getAllGroups() async {
    try {
      QuerySnapshot snapshot = await groupsCollection.getDocuments();
      List<Group> groups = [];
      snapshot.documents.forEach((DocumentSnapshot snapshot) {
        Group group = _groupFromSnapshot(snapshot);
        groups.add(group);
      });
      return groups;
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Lesen der Trainingsgruppen');
    }
  }

  String _getTraingsSessionDetails(TrainingSession session) {
    // List<String> jsonDetails = [];
    // session.details.forEach((d) {
    //   String jsonDetail = json.encode(d);
    //   jsonDetails.add(jsonDetail);
    // });
    // return json.encode(jsonDetails);
    return json.encode(session.details);
  }

  // training
  Future updateTrainingSession(TrainingSession session) async {
    try {
      session.uuid = session.uuid ?? Uuid().v1();
      session.uid = session.uid ?? uid;
      final Map<String, dynamic> data = {
        'uuid': session.uuid,
        'uid': session.uid,
        'dateString': session.convertDate2String(),
        'level': session.level,
        'trainingType': session.convertTrainingType2String(),
        'details': _getTraingsSessionDetails(session)
      };
      return await trainingSessionsCollection.document(session.uuid).setData(data);
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Speichern der Trainingseinheit');
    }
  }

  // error handling
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
