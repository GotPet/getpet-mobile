import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpet/authentication/authentication_manager.dart';

class UserProfileComponent extends StatelessWidget {
  final FirebaseUser user;

  UserProfileComponent({this.user});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 64,
                backgroundImage: getUserProfilePhotoProvider(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user.displayName ?? user.email,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
              child: RaisedButton.icon(
                icon: Icon(Icons.power_settings_new),
                label: Text("Atsijungti"),
                onPressed: _logout,
              ),
            ),
          ],
        ),
      );

  ImageProvider getUserProfilePhotoProvider() {
    if (user.photoUrl == null) {
      return AssetImage(
        "assets/anonymous_avatar.jpg",
      );
    } else {
      return NetworkImage(
        user.photoUrl,
      );
    }
  }

  void _logout() {
    AuthenticationManager().logout();
  }
}
