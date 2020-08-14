import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui/flutter_firebase_ui.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/components/user_profile/user_profile_component.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/routes.dart';
import 'package:getpet/widgets/conditions_rich_text.dart';

class UserLoginFullscreenComponent extends StatelessWidget {
  final bool popOnLoginIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).loginTitle),
      ),
      body: UserLoginOrProfileComponent(
        popOnLoginIn: this.popOnLoginIn,
      ),
    );
  }

  UserLoginFullscreenComponent({this.popOnLoginIn = false});
}

class UserLoginOrProfileComponent extends StatefulWidget {
  final bool popOnLoginIn;

  @override
  _UserLoginOrProfileComponentState createState() =>
      new _UserLoginOrProfileComponentState();

  UserLoginOrProfileComponent({this.popOnLoginIn = false});
}

class _UserLoginOrProfileComponentState
    extends State<UserLoginOrProfileComponent> {
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
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _currentUser == null
                ? UserLoginComponent()
                : UserProfileComponent(user: _currentUser),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: ConditionsRichText(),
          ),
          Visibility(
            visible: !this.widget.popOnLoginIn,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: FloatingActionButton.extended(
                icon: Icon(Icons.settings),
                label: Text(AppLocalizations.of(context).preferences),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.ROUTE_PREFERENCES,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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

class UserLoginComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: FractionallySizedBox(
              heightFactor: 0.65,
              child: Image.asset("assets/two_logos.png"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LoginView(
            providers: [
              ProvidersTypes.google,
              ProvidersTypes.facebook,
              ProvidersTypes.apple,
            ],
            passwordCheck: false,
            bottomPadding: 16,
            appleSignIn: true,
          ),
        ),
      ],
    );
  }
}
