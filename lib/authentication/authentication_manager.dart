import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/preferences/app_preferences.dart';

class AuthenticationManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final AuthenticationManager _singleton =
      new AuthenticationManager._internal();

  factory AuthenticationManager() {
    return _singleton;
  }

  AuthenticationManager._internal();

  final _appPreferences = AppPreferences();

  Future<bool> isLoggedIn() async {
    return (await getCurrentUser()) != null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future<String> getIdToken() async {
    final currentUser = await getCurrentUser();

    return await currentUser?.getIdToken(refresh: true);
  }

  StreamSubscription<FirebaseUser> listenForUser(
      void onData(FirebaseUser firebaseUser),
      {Function onError,
      void onDone(),
      bool cancelOnError}) {
    return _auth.onAuthStateChanged.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future logout() async {
    await signOutProviders();
    await _appPreferences.removeApiToken();
  }
}
