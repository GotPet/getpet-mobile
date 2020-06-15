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

  // Onboarding
  String get onboarding1Title => "Labas!";

  String get onboarding1Text =>
      "Nori būti mūsų draugu?\nSusipažink su programėle!";

  String get onboarding2Title => "Susižavėjai?";

  String get onboarding2Text =>
      "Nuslink patikusio gyvūno\nnuotrauką dešinėn - taip pridėsi\nją į mėgstamiausių sąrašą.";

  String get onboarding3Title => "Deja, ne šį kartą?";

  String get onboarding3Text => "Jei nesusižavėjai,\nnuslink nuotrauką kairėn.";

  String get onboarding4Title => "Susipažinkim!";

  String get onboarding4Text =>
      "Paspausk ant gyvūno nuotraukos\nir perskaityk jo istoriją.";

  String get onboarding5Title => "Priglausk!";

  String get onboarding5Text =>
      "Paspausk „GetPet“ ir sužinok,\nkur rasi savo draugą.";

  String get onboardingFinish => "Baigti";

  String get onboardingNext => "Kitas";

  // Shelter pet
  String get callShelter => "Skambinti į prieglaudą";

  String get pushAndContact =>
      "Spausk ir susisiek su prieglaudos atstovu.\nPaminėk, kad kreipiesi per GetPet ir susitark dėl pasimatymo!\n\nKai gyvūną priglausi į savo šeimą, GetPet paskirs tau asmeninį mentorių sklandžiai draugystės pradžiai.";

  String get errorUnableToCallShelter =>
      "Nepavyko atidaryti skambinimo programos. Surinkite prieglaudos numerį ir susisiekite.";

  String get errorUnableToEmailShelter =>
      "Nepavyko atidaryti el. pašto programos. Išsiųskite elektroninį laišką prieglaudai ir susisiekite.";

  // Swipe pets
  String get noMorePetsToSwipe =>
      "O ne!\nSąrašas baigėsi.\nPatikrink savo simpatijas!";

  String get errorLoadingPets => "Klaida kraunant gyvūnus";

  // Favorites list
  String get myGetPetRequests => "Išrinktieji";

  String get myFavoritePets => "Simpatijos";

  String get emptyFavoritesList =>
      "Mėgstamiausių gyvūnų sąrašas tuščias,\nlaikas susirasti simpatiją!";

  // Pet profile
  String get myStory => "Mano istorija";

  String get deletePet => "Šalinti gyvūną iš sąrašo";

  String get readyForDate => "Pasiruošęs pasimatymui?";

  // Pet remove dialog
  String get petRemoveDialogMessage =>
      "Ar nori pašalinti gyvūną iš mėgstamiausių sąrašo?";

  String get petRemove => "Pašalinti";

  String get petRemoveDialogTitle => "Pašalinti";

  String get petRemoveDialogCancel => "Atšaukti";

  String get petRemoveDialogOk => "Taip";

  // User profile
  String get loginTitle => "Prisijunkite";

  String get loginConditionsDescription =>
      "Prisijungdami Jūs patvirtinate, kad sutinkate su GetPet";

  String get fairUseRules => "Sąžiningo naudojimosi taisyklėmis";

  String get logout => "Atsijungti";

  String get privacyPolicy => "Privatumo politika";

  String get and => "ir";

  String get userGuide => "Instrukcija";

  // General
  String get retryOnError => "Bandyti dar kartą";
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
