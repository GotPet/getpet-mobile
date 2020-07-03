import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:getpet/pets.dart';

class Analytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver firebaseObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  static const EVENT_CALL_SHELTER = "call_shelter";
  static const EVENT_EMAIL_SHELTER = "email_shelter";
  static const EVENT_PET_LIKED = "pet_liked";
  static const EVENT_PET_DISLIKED = "pet_disliked";
  static const EVENT_PET_GETPET = "pet_getpet";
  static const EVENT_PET_PROFILE_OPENED_WHILE_SWIPING = "pet_open_profile_while_swiping";

  static final Analytics _singleton = new Analytics._internal();

  factory Analytics() {
    return _singleton;
  }

  Analytics._internal();

  Future logShelterCall(Pet pet) async {
    return await analytics.logEvent(
      name: EVENT_CALL_SHELTER,
      parameters: _getPetParameters(pet),
    );
  }

  Future logShelterEmail(Pet pet) async {
    return await analytics.logEvent(
      name: EVENT_EMAIL_SHELTER,
      parameters: _getPetParameters(pet),
    );
  }

  Future logOnboardingBegin() async {
    return await analytics.logTutorialBegin();
  }

  Future logOnboardingComplete() async {
    return await analytics.logTutorialComplete();
  }

  Future logPetLiked(Pet pet) async {
    return await analytics.logEvent(
      name: EVENT_PET_LIKED,
      parameters: _getPetParameters(pet),
    );
  }

  Future logPetDisliked(Pet pet) async {
    return await analytics.logEvent(
      name: EVENT_PET_DISLIKED,
      parameters: _getPetParameters(pet),
    );
  }
  Future logPetGetPet(Pet pet) async {
    return await analytics.logEvent(
      name: EVENT_PET_GETPET,
      parameters: _getPetParameters(pet),
    );
  }

  Future logPetProfileOpenedWhileSwiping(Pet pet) async {
    return await analytics.logEvent(
      name: EVENT_PET_PROFILE_OPENED_WHILE_SWIPING,
      parameters: _getPetParameters(pet),
    );
  }

  Map<String, dynamic> _getPetParameters(Pet pet) {
    return {
      'pet_id': pet.id,
      'pet_name': pet.name,
      'shelter_id': pet.shelter.id,
      'shelter_name': pet.shelter.name,
    };
  }
}
