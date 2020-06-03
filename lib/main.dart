import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getpet/components/app/app_component.dart';
import 'package:getpet/repositories/pets_db_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZonedGuarded<Future<void>>(() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await PetsDBRepository().initDb();

    runApp(new AppComponent());
  }, (Object error, StackTrace stack) {
    Crashlytics.instance.recordError(error, stack);
  });
}
