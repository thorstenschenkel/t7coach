import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // https://github.com/firebase/FirebaseUI-Android/blob/master/auth/src/main/java/com/firebase/ui/auth/util/FirebaseAuthError.java
  static const errorTexts = {
    'ERROR_INVALID_EMAIL': 'Bitte gib eine gültige E-Mail-Adresse ein.',
    'ERROR_WEAK_PASSWORD':
        'Wähle ein sicheres Passwort. Das Passwort muss mit mindestens 8 Zeichen lang sein. ',
    'ERROR_EMAIL_ALREADY_IN_USE':
        'Die E-Mail-Adresse wird bereits verwendet. Versuche es mit einer anderen E-Mail-Adresse.',
    'ERROR_MISSING_EMAIL':
        'E-Mail-Adresse fehlt. Bitte gib eine E-Mail-Adresse ein.',
    'ERROR_MISSING_PASSWORD': 'Passwort fehlt. Bitte gib ein Passwort ein.',
    'ERROR_USER_NOT_FOUND': 'Es existiert kein Profil zur eingegeben E-Mail-Adresse',
    'ERROR_WRONG_PASSWORD': 'Passwort ist ungültig.'
  };

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

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return _exceptionToError(e, 'Fehler beim Anmelden');
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return _exceptionToError(e, 'Fehler beim Abmelden');
    }
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
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
