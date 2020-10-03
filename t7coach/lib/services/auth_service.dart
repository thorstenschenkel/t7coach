import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:t7coach/models/auth_error.dart';
import 'package:t7coach/models/user.dart';
import 'package:t7coach/models/user_data.dart';

import 'datadase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final logger = Logger();

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
    if (user == null) {
      return null;
    }

    return User(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        providerId: user.providerId,
        signInMethod: user.providerData?.last?.providerId);
  }

  Future createNewUserData(String uid) async {
    if (await DatabaseService(uid: uid).getUserData() == null) {
      final userData = UserData(uid: uid);
      userData.accountColor = Colors.primaries[Random().nextInt(Colors.primaries.length)].value;
      await DatabaseService(uid: uid).updateUserData(userData);
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await createNewUserData(user.uid);
      return _userFromFirebaseUser(user);
    } catch (e) {
      logger.w(e);
      return _exceptionToError(e, 'Fehler beim Registrieren');
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      logger.w(e);
      return _exceptionToError(e, 'Fehler beim Anmelden');
    }
  }

  Future signOut(User user) async {
    try {
      switch (user.signInMethod) {
        case GoogleAuthProvider.providerId:
          await _googleSignIn.signOut();
          logger.d({'signInMethod': user.signInMethod});
          print({'method': 'signOut', 'provider': 'google'});
          break;
        case FacebookAuthProvider.providerId:
          await _facebookLogin.logOut();
          logger.d({'signInMethod': user.signInMethod});
          print({'method': 'logOut', 'provider': 'facebook'});
          break;
      }
      logger.d({'signInMethod': 'firebase'});
      return await _auth.signOut();
    } catch (e) {
      logger.w(e);
      return _exceptionToError(e, 'Fehler beim Abmelden');
    }
  }

  Future sendPasswortResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      logger.w(e);
      return _exceptionToError(e, 'Fehler beim Zurücksetzen des Passworts');
    }
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  Future signInWithGoogle() async {
    try {
      // // Attempt to get the currently authenticated user
      // GoogleSignInAccount googleAccount = _googleSignIn.currentUser;
      // if (googleAccount == null) {
      //   // Attempt to sign in without user interaction
      //   googleAccount = await _googleSignIn.signInSilently();
      // } else {
      //   logger.d({'signInWithGoogle': 'currentUser exits'});
      // }
      // if (googleAccount == null) {
      //   // Force the user to interactively sign in
      //   googleAccount = await _googleSignIn.signIn();
      //   logger.d({'signInWithGoogle': 'signIn'});
      // } else {
      //   logger.d({'signInWithGoogle': 'signInSilently'});
      // }
      GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
      AuthCredential credential =
          GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      await createNewUserData(user.uid);
      logger.d({'method': 'signInWithGoogle'});
      return _userFromFirebaseUser(user);
    } catch (e) {
      logger.w(e);
      return _exceptionToError(e, 'Fehler beim Anmelden mit Google');
    }
  }

  Future signInWithFacebook() async {
    final FacebookLoginResult fbResult = await _facebookLogin.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email]
    );
    switch (fbResult.status) {
      case FacebookLoginStatus.Success:
        FacebookAccessToken fbToken = fbResult.accessToken;
        AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: fbToken.token);
        AuthResult result = await _auth.signInWithCredential(credential);
        FirebaseUser user = result.user;
        await createNewUserData(user.uid);
        logger.d({'method': 'signInWithFacebook'});
        return _userFromFirebaseUser(user);
      case FacebookLoginStatus.Cancel:
        logger.d('facebook login was canceled');
        break;
      case FacebookLoginStatus.Error:
        logger.e(fbResult.error);
        // TODO
        break;
      default:
        logger.e('unexcpexted facebook login status',  fbResult.status);
        return _exceptionToError(e, 'Fehler beim Anmelden mit Facebook');
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
