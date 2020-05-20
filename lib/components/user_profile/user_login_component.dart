import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui/flutter_firebase_ui.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/components/user_profile/user_profile_component.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/widgets/conditions_rich_text.dart';

class UserLoginFullscreenComponent extends StatelessWidget {
  final bool popOnLoginIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).loginTitle),
      ),
      body: UserLoginComponent(
        popOnLoginIn: this.popOnLoginIn,
      ),
    );
  }

  UserLoginFullscreenComponent({this.popOnLoginIn = false});
}

class UserLoginComponent extends StatefulWidget {
  final bool popOnLoginIn;

  @override
  _UserLoginComponentState createState() => new _UserLoginComponentState();

  UserLoginComponent({this.popOnLoginIn = false});
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
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
                child: ConditionsRichText(),
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
        if (user != null && widget.popOnLoginIn) {
          Navigator.pop(context, true);
        }

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
