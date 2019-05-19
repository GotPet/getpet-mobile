import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui/flutter_firebase_ui.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/components/user_profile/user_profile_component.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/widgets/privacy_policy_button.dart';
import 'package:getpet/widgets/user_guide_button.dart';

class UserLoginFullscreenComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).loginTitle),
      ),
      body: UserLoginComponent(),
    );
  }
}

class UserLoginComponent extends StatefulWidget {
  @override
  _UserLoginComponentState createState() => new _UserLoginComponentState();
}

class _UserLoginComponentState extends State<UserLoginComponent> {
  final _authenticationManager = AuthenticationManager();

  StreamSubscription<FirebaseUser> _listener;

  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    _listener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Container(
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: Image.asset("assets/two_logos.png"),
                ),
              ),
              new Expanded(
                child: new LoginView(
                  providers: [
                    ProvidersTypes.google,
                    ProvidersTypes.facebook,
                  ],
                  passwordCheck: false,
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
          ));
    } else {
      return UserProfileComponent(user: _currentUser);
    }
  }

  void _checkCurrentUser() async {
    _currentUser = await _authenticationManager.getCurrentUser();
    setState(() {});

    _listener = _authenticationManager.listenForUser((FirebaseUser user) {
      if (_listener != null) {
        setState(() {
          _currentUser = user;
        });
      }
    }, onError: (ex) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(ex.toString()),
        ),
      );
    });
  }
}
