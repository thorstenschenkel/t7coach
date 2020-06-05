import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';

import 'datadase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // https://github.com/firebase/FirebaseUI-Android/blob/master/auth/src/main/java/com/firebase/ui/auth/util/FirebaseAuthError.java
  static const errorTexts = {
    'ERROR_INVALID_EMAIL': 'Bitte gib eine gültige E-Mail-Adresse ein.',
    'ERROR_WEAK_PASSWORD': 'Wähle ein sicheres Passwort. Das Passwort muss mit mindestens 8 Zeichen lang sein. ',
    'ERROR_EMAIL_ALREADY_IN_USE':
        'Die E-Mail-Adresse wird bereits verwendet. Versuche es mit einer anderen E-Mail-Adresse.',
    'ERROR_MISSING_EMAIL': 'E-Mail-Adresse fehlt. Bitte gib eine E-Mail-Adresse ein.',
    'ERROR_MISSING_PASSWORD': 'Passwort fehlt. Bitte gib ein Passwort ein.',
    'ERROR_USER_NOT_FOUND': 'Es existiert kein Profil zur eingegeben E-Mail-Adresse',
    'ERROR_WRONG_PASSWORD': 'Passwort ist ungültig.'

    ///  * `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///  * `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///  * `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  };

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      final userData = UserData(uid: user.uid);
      userData.accountColor = Colors.primaries[Random().nextInt(Colors.primaries.length)].value;
      await DatabaseService(uid: user.uid).updateUserData(userData);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Registrieren');
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Anmelden');
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return _exceptionToError(e, 'Fehler beim Abmelden');
    }
  }

  Future sendPasswortResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return _exceptionToError(e, 'Fehler beim Zurücksetzen des Passworts');
    }
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
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
