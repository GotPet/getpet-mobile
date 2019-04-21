import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/widgets/privacy_policy_button.dart';
import 'package:getpet/widgets/user_guide_button.dart';

class UserProfileComponent extends StatelessWidget {
  final FirebaseUser user;

  UserProfileComponent({this.user});

  @override
  Widget build(BuildContext context) => Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.transparent,
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
                      label: Text(AppLocalizations.of(context).logout),
                      onPressed: _logout,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserGuideButton(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: PrivacyPolicyButton(),
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
      var photoUrl = user.photoUrl;

      photoUrl = photoUrl.replaceAll("/s96-c/", "/s300-c/");
      photoUrl += "?height=300";
      return NetworkImage(
        photoUrl,
      );
    }
  }

  _logout() async {
    await AuthenticationManager().logout();
  }
}
