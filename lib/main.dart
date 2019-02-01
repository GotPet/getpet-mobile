import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getpet/components/app/app_component.dart';
import 'package:getpet/repositories/pets_db_repository.dart';
import 'package:getpet/utils/crash_reporting.dart';
import 'package:getpet/utils/debug_utils.dart';

Future<Null> main() async {
  final CrashReporting crashReporting = await CrashReporting().init();

  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await PetsDBRepository().initDb();

    runApp(new AppComponent());
  }, onError: (error, stackTrace) async {
    await crashReporting.reportError(error, stackTrace);
  });
}
