import 'package:getpet/pets.dart';
import 'package:getpet/repositories/pets_db_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PetsService {
  static final PetsService _singleton = new PetsService._internal();

  factory PetsService() {
    return _singleton;
  }

  PetsService._internal();

  Future<List<Pet>> getFavoritePets() async {
    return await PetsDBRepository().getPetsFavorites();
  }

  Future<List<Pet>> getPetsToSwipe() async {
    final favoritePetIds = await PetsDBRepository().getFavoritePetIds();
    final dislikedPetIds = await PetsDBRepository().getDislikedPetIds();

    final response = await http.post(
      'https://www.getpet.lt/api/v1/pets/generate/',
      body: json.encode(
        {
          "liked_pets": favoritePetIds,
          "disliked_pets": dislikedPetIds,
        },
      ),
      headers: {
        'content-type': 'application/json',
        'charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      List<Pet> pets = json
          .decode(utf8.decode(response.bodyBytes))
          .map<Pet>((model) => Pet.fromJson(model))
          .toList();

      final dislikedPets =
          await PetsDBRepository().getDislikedPetsOrderedByRandom();

      await PetsDBRepository().insertPets(
        pets,
        onConflictReplace: true,
      );

      pets.addAll(dislikedPets);

      return pets;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future likePet(Pet pet) async {
    await PetsDBRepository().insertPetChoice(pet, Decision.like);
  }

  Future dislikePet(Pet pet) async {
    return await PetsDBRepository().insertPetChoice(pet, Decision.nope);
  }
}
