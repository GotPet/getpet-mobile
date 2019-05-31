import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:getpet/pets.dart';

class Analytics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics();

  static const EVENT_CALL_SHELTER = "call_shelter";
  static const EVENT_EMAIL_SHELTER = "email_shelter";

  static final Analytics _singleton = new Analytics._internal();

  factory Analytics() {
    return _singleton;
  }

  Analytics._internal();

  Future logShelterCall(Pet pet) async {
    return await _analytics
        .logEvent(name: EVENT_CALL_SHELTER, parameters: <String, dynamic>{
      'pet_id': pet.id,
      'pet_name': pet.name,
      'shelter_id': pet.shelter.id,
      'shelter_name': pet.shelter.name,
    });
  }

  Future logShelterEmail(Pet pet) async {
    return await _analytics
        .logEvent(name: EVENT_EMAIL_SHELTER, parameters: <String, dynamic>{
      'pet_id': pet.id,
      'pet_name': pet.name,
      'shelter_id': pet.shelter.id,
      'shelter_name': pet.shelter.name,
    });
  }

  Future logOnboardingBegin() async {
    return await _analytics.logTutorialBegin();
  }

  Future logOnboardingComplete() async {
    return await _analytics.logTutorialComplete();
  }
}
