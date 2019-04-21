import 'package:flutter/material.dart';
import 'package:getpet/components/onboarding/onboarding_component.dart';
import 'package:getpet/localization/app_localization.dart';

class UserGuideButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(Icons.description),
      label: Text(AppLocalizations.of(context).userGuide),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OnboardingComponent()),
        );
      },
    );
  }
}
