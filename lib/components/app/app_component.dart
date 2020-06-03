import 'package:flutter/material.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/localization/firebase_localization.dart';
import 'package:getpet/repositories/pets_db_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:getpet/routes.dart';

class AppComponent extends StatefulWidget {
  @override
  _AppComponentState createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> {
  @override
  Future deactivate() async {
    await PetsDBRepository().dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      initialRoute: Routes.ROUTE_HOME,
      onGenerateRoute: Routes.onGenerateRoute,
      theme: ThemeData(
        primaryColor: Color.fromARGB(0xFF, 0xDD, 0x61, 0x72),
        primaryColorDark: Color.fromARGB(0xFF, 0x93, 0x1F, 0x33),
        accentColor: Colors.white,
        textTheme: TextTheme(
          body1: TextStyle(
              fontSize: 14.0, color: Color.fromARGB(0xFF, 0x66, 0x66, 0x66)),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseLocalization.delegate,
        AppLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('lt', 'LT'),
        const Locale('en', 'US'),
      ],
    );
  }
}
