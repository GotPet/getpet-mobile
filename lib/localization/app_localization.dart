import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      const AppLocalizationDelegate();

  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appTitle => "GetPet";

  String get callShelter => "Skambinti į prieglaudą";

  String get errorUnableToCallShelter =>
      "Nepavyko atidaryti skambinimo programos. Surinkite prieglaudos numerį ir susisiekite.";

  String get errorUnableToEmailShelter =>
      "Nepavyko atidaryti el. pašto programos. Išsiųskite elektroninį laišką prieglaudai ir susisiekite.";
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
