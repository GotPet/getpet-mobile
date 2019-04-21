import 'package:flutter/material.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(Icons.lock),
      label: Text(AppLocalizations.of(context).privacyPolicy),
      onPressed: () async {
        await launch('https://www.getpet.lt/privatumo-politika');
      },
    );
  }
}
