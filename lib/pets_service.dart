import 'package:getpet/analytics/analytics.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/api/pets_api_service.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/preferences/app_preferences.dart';
import 'package:getpet/repositories/pets_db_repository.dart';
import 'dart:async';

class PetsService {
  static final PetsService _singleton = new PetsService._internal();

  factory PetsService() {
    return _singleton;
  }

  PetsService._internal();

  final _petsDBRepository = PetsDBRepository();
  final _petsApiService = PetsApiService();
  final _authenticationManager = AuthenticationManager();
  final _appPreferences = AppPreferences();
  final _analytics = Analytics();

  Stream<List<Pet>> getFavoritePets() {
    return _petsDBRepository.getPetsFavorites();
  }

  Future updatePetProfiles() async {
    final favoritePetIds = await _petsDBRepository.getFavoritePetIds();
    final lastUpdateDateISO =
        await _appPreferences.getLastPetProfilesUpdateISODate();

    final petsToUpdate =
        await _petsApiService.getPets(favoritePetIds, lastUpdateDateISO);

    await _petsDBRepository.updatePets(petsToUpdate);

    final currentIsoUTC = DateTime.now().toUtc().toIso8601String();
    await _appPreferences.setLastPetProfilesUpdateISODate(currentIsoUTC);
  }

  Future<List<Pet>> getPetsToSwipe() async {
    final favoritePetIds = await _petsDBRepository.getFavoritePetIds();
    final dislikedPetIds = await _petsDBRepository.getDislikedPetIds();
    final petType = await _appPreferences.getSelectedPetType() ?? PetType.dog;

    var pets = await _petsApiService.generatePetsToSwipe(
      favoritePetIds,
      dislikedPetIds,
      petType,
    );

    await _petsDBRepository.removePetsWithoutChoice();
    await _petsDBRepository.insertPets(pets);

    return pets;
  }

  Future likePet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, PetDecision.like);
    await _analytics.logPetLiked(pet);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.likePet(pet);
    }
  }

  Future dislikePet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, PetDecision.dislike);
    await _analytics.logPetDisliked(pet);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.dislikePet(pet);
    }
  }

  Future shelterPet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, PetDecision.getPet);
    await _analytics.logPetGetPet(pet);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.shelterPet(pet);
    }
  }
}
