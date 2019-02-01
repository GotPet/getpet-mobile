import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/api/pets_api_service.dart';
import 'package:getpet/pets.dart';
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

  Stream<List<Pet>> getFavoritePets() {
    return _petsDBRepository.getPetsFavorites();
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
    await _petsDBRepository.insertPetChoice(pet, PetDecision.like);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.likePet(pet);
    }
  }

  Future dislikePet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, PetDecision.dislike);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.dislikePet(pet);
    }
  }

  Future shelterPet(Pet pet) async {
    await _petsDBRepository.insertPetChoice(pet, PetDecision.getPet);

    if (await _authenticationManager.isLoggedIn()) {
      await _petsApiService.shelterPet(pet);
    }
  }
}
