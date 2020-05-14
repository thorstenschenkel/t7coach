import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const errorTexts = {'ERROR_INVALID_EMAIL': 'Bitte gib eine gültige E-Mail-Adresse ein.'};

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
//      await DatabaseService(uid: user.uid)
//          .updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Registrieren');
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  AuthError _exceptionToError(exception, String defaultText) {
    String errorText = defaultText;
    if (exception is PlatformException) {
      if (errorTexts.containsKey(exception.code)) {
        errorText = errorTexts[exception.code];
      }
    }
    return AuthError(errorText: errorText);
  }
}
