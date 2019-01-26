import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/components/api/pets_api_service.dart';
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
  final _appPreferences = AppPreferences();
  final _authenticationManager = AuthenticationManager();

  Future<String> fetchApiToken(String idToken) async {
    final apiToken = await _petsApiService.authenticate(idToken);

    await _appPreferences.setApiToken(apiToken);

    return apiToken;
  }

  Future<List<Pet>> getFavoritePets() async {
    return await _petsDBRepository.getPetsFavorites();
  }

  Future<List<Pet>> getPetsToSwipe() async {
    final favoritePetIds = await _petsDBRepository.getFavoritePetIds();
    final dislikedPetIds = await _petsDBRepository.getDislikedPetIds();

    final dislikedPets =
        await _petsDBRepository.getDislikedPetsOrderedByRandom();

    var pets = await _petsApiService.generatePetsToSwipe(
        favoritePetIds, dislikedPetIds);

    await _petsDBRepository.removePetsWithoutChoice();
    await _petsDBRepository.insertPets(
      pets,
      onConflictReplace: true,
    );

    pets.addAll(dislikedPets);

    return pets;
  }

  Future likePet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, Decision.like);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.likePet(pet);
    }
  }

  Future dislikePet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, Decision.nope);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.dislikePet(pet);
    }
  }

  Future shelterPet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, Decision.superLike);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.shelterPet(pet);
    }
  }
}
