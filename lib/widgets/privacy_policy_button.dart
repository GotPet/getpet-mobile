import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      child: RaisedButton.icon(
        icon: Icon(Icons.description),
        label: Text("Privatumo politika"),
        onPressed: () async {
          await launch('https://www.getpet.lt/privatumo-politika');
        },
      ),
    );
  }
}
