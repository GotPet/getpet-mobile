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

  Future<String> fetchApiToken(String idToken) async {
    final apiToken = await PetsApiService().authenticate(idToken);

    await AppPreferences().setApiToken(apiToken);

    return apiToken;
  }

  Future<List<Pet>> getFavoritePets() async {
    return await PetsDBRepository().getPetsFavorites();
  }

  Future<List<Pet>> getPetsToSwipe() async {
    final favoritePetIds = await PetsDBRepository().getFavoritePetIds();
    final dislikedPetIds = await PetsDBRepository().getDislikedPetIds();

    final dislikedPets =
        await PetsDBRepository().getDislikedPetsOrderedByRandom();

    var pets = await PetsApiService()
        .generatePetsToSwipe(favoritePetIds, dislikedPetIds);

    await PetsDBRepository().removePetsWithoutChoice();
    await PetsDBRepository().insertPets(
      pets,
      onConflictReplace: true,
    );

    pets.addAll(dislikedPets);

    return pets;
  }

  Future likePet(Pet pet) async {
    await PetsDBRepository().insertPetChoice(pet, Decision.like);
  }

  Future dislikePet(Pet pet) async {
    return await PetsDBRepository().insertPetChoice(pet, Decision.nope);
  }
}
