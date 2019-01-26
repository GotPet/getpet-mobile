import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getpet/components/app/app_component.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new AppComponent());
  });
}
