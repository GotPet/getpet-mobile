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
    final apiToken = await _appPreferences.getApiToken();
    if (apiToken == null) {
      return false;
    }

    final currentUser = await getCurrentUser();

    return currentUser != null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future<FirebaseUser> getCurrentUserWithRefresh() async {
    final currentUser = await getCurrentUser();

    if (currentUser == null) {
      return null;
    }

    final idToken = await currentUser.getIdToken(refresh: true);
    await PetsService().fetchApiToken(idToken);

    return await _auth.currentUser();
  }

  StreamSubscription<FirebaseUser> listenForUser(
      void onData(FirebaseUser firebaseUser),
      {Function onError,
      void onDone(),
      bool cancelOnError}) {
    return _auth.onAuthStateChanged.listen(
      (FirebaseUser user) async {
        try {
          await getCurrentUserWithRefresh();
        } catch (ex) {
          print(ex);
        }

        onData(user);
      },
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
