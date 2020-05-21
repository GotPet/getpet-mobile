import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/widgets/conditions_rich_text.dart';
import 'package:getpet/widgets/getpet_network_image.dart';

class UserProfileComponent extends StatelessWidget {
  final FirebaseUser user;

  UserProfileComponent({this.user});

  @override
  Widget build(BuildContext context) => Container(
        decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
        child: new Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 128,
                      height: 128,
                      child: getUserProfilePhotoProvider(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    user.displayName ?? user.email,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: Image.asset("assets/two_logos.png"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
              child: ConditionsRichText(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FloatingActionButton.extended(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: _logout,
                  label: Text(AppLocalizations.of(context).logout)),
            ),
          ],
        ),
      );

  Widget getUserProfilePhotoProvider() {
    final anonymousImage = Image.asset("assets/anonymous_avatar.jpg");

    if (user.photoUrl != null) {
      var photoUrl = user.photoUrl.replaceFirst("/s96-c/", "/s300-c/");
      photoUrl += "?height=300";

      return GetPetNetworkImage(
        url: photoUrl,
        useDiskCache: true,
        placeholder: anonymousImage,
      );
    }

    return anonymousImage;
  }

  _logout() async {
    await AuthenticationManager().logout();
  }
}
