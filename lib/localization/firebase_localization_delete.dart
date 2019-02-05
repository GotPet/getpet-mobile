import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ui/l10n/localization.dart';

class FirebaseLocalization extends FFULocalizations {
  FirebaseLocalization(Locale locale) : super(locale);

  @override
  String get signInFacebook => "Prisijungti su Facebook";

  @override
  String get signInGoogle => "Prisijungti su Google";

  static const LocalizationsDelegate<FFULocalizations> delegate =
      const _FirebaseLocalizationDelegate();

  static Future<FirebaseLocalization> load(Locale locale) {
    return new SynchronousFuture<FirebaseLocalization>(
        new FirebaseLocalization(locale));
  }
}

class _FirebaseLocalizationDelegate
    extends LocalizationsDelegate<FFULocalizations> {
  const _FirebaseLocalizationDelegate();

  static const List<String> _supportedLanguages = const <String>[
    'en', // English
    'fr', // French
    'de', // Deutsch
    'pt', // Portuguese
  ];

  @override
  bool isSupported(Locale locale) =>
      _supportedLanguages.contains(locale.languageCode);

  @override
  Future<FFULocalizations> load(Locale locale) =>
      FirebaseLocalization.load(locale);

  @override
  bool shouldReload(_FirebaseLocalizationDelegate old) => false;
}
