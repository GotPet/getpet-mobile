import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:getpet/pets_service.dart';

class AuthenticationManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final AuthenticationManager _singleton =
      new AuthenticationManager._internal();

  factory AuthenticationManager() {
    return _singleton;
  }

  AuthenticationManager._internal();

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
}
