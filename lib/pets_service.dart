import 'dart:io';

import 'package:flutter/services.dart';
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

  Stream<List<Pet>> getFavoritePets() {
    return _petsDBRepository.getPetsFavorites();
  }

  Future<int> syncLegacyPets() async {
    if (!Platform.isAndroid) {
      return 0;
    }

    try {
      var result =
          await MethodChannel('lt.getpet.getpet').invokeMethod('getLegacyPets');
      result = Map<String, List<dynamic>>.from(result)
          .map((k, v) => MapEntry(k, List<int>.from(v)));

      final likedPetIds = List<int>.from(result['linkedPetIds']) ?? [];
      final petIdsWithRequest =
          List<int>.from(result['petIdsWithRequest']) ?? [];

      final likedPetIdsSet = likedPetIds.toSet();
      final petIdsWithRequestSet = petIdsWithRequest.toSet();

      final allPetIds = [...likedPetIds, ...petIdsWithRequest];
      final allPets = await _petsApiService.getPets(allPetIds);

      final likedPets =
          allPets.where((p) => likedPetIdsSet.contains(p.id)).toList();
      final petsWithRequest =
          allPets.where((p) => petIdsWithRequestSet.contains(p.id)).toList();

      await _petsDBRepository.insertPets(
        allPets,
        onConflictReplace: true,
      );

      for (final pet in likedPets) {
        await _petsDBRepository.insertPetChoice(pet, PetDecision.like);
      }

      for (final pet in petsWithRequest) {
        await _petsDBRepository.insertPetChoice(pet, PetDecision.getPet);
      }

      await _appPreferences.setLegacyPetsMigrated();

      return allPets.length;
    } catch (exception, stackTrace) {
      Zone.current.handleUncaughtError(exception, stackTrace);
      return 0;
    }
  }

  Future<int> syncLegacyPetsIfNeeded() async {
    if (Platform.isAndroid && !(await _appPreferences.isLegacyPetsMigrated())) {
      return await syncLegacyPets();
    }

    return 0;
  }

  Future<List<Pet>> getPetsToSwipe() async {
    await syncLegacyPetsIfNeeded();

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
