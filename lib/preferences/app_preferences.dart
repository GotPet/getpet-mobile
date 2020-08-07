import 'dart:async';

import 'package:getpet/pets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _KEY_API_TOKEN = "GETPET_API_TOKEN";
  static const _KEY_LAST_PET_PROFILES_UPDATE_ISO_DATE =
      "LAST_PET_PROFILES_UPDATE_ISO_DATE";
  static const _KEY_ONBOARDING_PASSED = "ONBOARDING_PASSED";
  static const _KEY_SELECTED_PET_TYPE = "SELECTED_PET_TYPE";

  static final AppPreferences _singleton = new AppPreferences._internal();

  factory AppPreferences() {
    return _singleton;
  }

  AppPreferences._internal();

  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> get sharedPreferences async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    }
    _sharedPreferences = await SharedPreferences.getInstance();

    return _sharedPreferences;
  }

  final _petTypeController = StreamController<PetType>.broadcast();

  Stream<PetType> get petPreferenceChangeStream => _petTypeController.stream;

  Future setApiToken(String apiToken) async {
    var prefs = await sharedPreferences;

    return await prefs.setString(_KEY_API_TOKEN, apiToken);
  }

  Future<String> getApiToken() async {
    var prefs = await sharedPreferences;

    return prefs.getString(_KEY_API_TOKEN);
  }

  Future<String> getLastPetProfilesUpdateISODate() async {
    var prefs = await sharedPreferences;

    return prefs.getString(_KEY_LAST_PET_PROFILES_UPDATE_ISO_DATE);
  }

  Future setLastPetProfilesUpdateISODate(String isoDate) async {
    var prefs = await sharedPreferences;

    return await prefs.setString(
        _KEY_LAST_PET_PROFILES_UPDATE_ISO_DATE, isoDate);
  }

  Future removeApiToken() async {
    var prefs = await sharedPreferences;

    return await prefs.remove(_KEY_API_TOKEN);
  }

  Future setOnboardingPassed() async {
    var prefs = await sharedPreferences;

    return await prefs.setBool(_KEY_ONBOARDING_PASSED, true);
  }

  Future<bool> isOnboardingPassed() async {
    var prefs = await sharedPreferences;

    if (prefs.containsKey(_KEY_ONBOARDING_PASSED)) {
      return prefs.getBool(_KEY_ONBOARDING_PASSED);
    }
    return false;
  }

  Future setSelectedPetType(PetType petType) async {
    var prefs = await sharedPreferences;

    final res = await prefs.setInt(_KEY_SELECTED_PET_TYPE, petType.index);

    _petTypeController.add(petType);
    return res;
  }

  Future<PetType> getSelectedPetType() async {
    var prefs = await sharedPreferences;

    if (!prefs.containsKey(_KEY_ONBOARDING_PASSED)) {
      return null;
    }

    final petTypeIndex = prefs.getInt(_KEY_SELECTED_PET_TYPE);

    return PetType.values[petTypeIndex];
  }

  dispose() {
    _petTypeController.close();
  }
}
