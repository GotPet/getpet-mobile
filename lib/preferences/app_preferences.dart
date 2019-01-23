import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _KEY_API_TOKEN = "GETPET_API_TOKEN";
  static const _KEY_ONBOARDING_PASSED = "ONBOARDING_PASSED";

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

  Future setApiToken(String apiToken) async {
    var prefs = await sharedPreferences;

    return await prefs.setString(_KEY_API_TOKEN, apiToken);
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

    return prefs.getBool(_KEY_ONBOARDING_PASSED) ?? false;
  }
}
