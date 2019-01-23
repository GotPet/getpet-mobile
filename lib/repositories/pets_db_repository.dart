import 'dart:convert';

import 'package:getpet/pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PetsDBRepository {
  static Database _db;

  static final PetsDBRepository _instance = new PetsDBRepository.internal();

  factory PetsDBRepository() => _instance;

  static const _tableShelters = "Shelters";
  static const _columnShelterId = "shelter_id";
  static const _columnShelterName = "shelter_name";
  static const _columnShelterEmail = "shelter_email";
  static const _columnShelterPhone = "shelter_phone";

  static const _tablePets = "Pets";
  static const _columnPetId = "pet_id";
  static const _columnPetShelterId = "pet_shelter_id";
  static const _columnPetAvailable = "pet_available";
  static const _columnPetProfilePhoto = "pet_profile_photo";
  static const _columnPetName = "pet_name";
  static const _columnPetShortDescription = "pet_short_description";
  static const _columnPetDescription = "pet_description";
  static const _columnPetPhotosJson = "pet_photos_json";

  static const _tablePetChoices = "PetChoices";
  static const _columnPetChoicesId = "pet_choice_id";
  static const _columnPetChoicesPetId = "pet_choice_pet_id";
  static const _columnPetChoicesChoice = "pet_choice_choice";
  static const _columnPetChoicesCreatedAt = "pet_choice_created_at";

  static const _indexPetChoicesPetId = "index_PetChoices_pet_id";
  static const _indexPetChoicesChoice = "index_PetChoices_choice";

  static const _petDecisionNumDislike = 1;
  static const _petDecisionNumLike = 2;
  static const _petDecisionNumGetPet = 3;

  PetsDBRepository.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'getpet-pets.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  Future _onCreate(Database db, int newVersion) async {
    await db.execute("""
CREATE TABLE IF NOT EXISTS `$_tableShelters` (
  `$_columnShelterId` INTEGER NOT NULL, 
  `$_columnShelterName` TEXT NOT NULL, 
  `$_columnShelterEmail` TEXT NOT NULL, 
  `$_columnShelterPhone` TEXT NOT NULL, 
  PRIMARY KEY(`$_columnShelterId`)
);
""");

    await db.execute("""
CREATE TABLE IF NOT EXISTS `$_tablePets` (
  `$_columnPetId` INTEGER NOT NULL,
  `$_columnPetShelterId` INTEGER NOT NULL,
  `$_columnPetName` TEXT NOT NULL,
  `$_columnPetAvailable` INTEGER NOT NULL,
  `$_columnPetProfilePhoto` TEXT NOT NULL,
  `$_columnPetShortDescription` TEXT NOT NULL,
  `$_columnPetDescription` TEXT NOT NULL,
  `$_columnPetPhotosJson` TEXT NOT NULL,
  PRIMARY KEY(`$_columnPetId`),
  FOREIGN KEY(`$_columnPetShelterId`) REFERENCES `$_tableShelters`(`$_columnShelterId`) ON UPDATE NO ACTION ON DELETE CASCADE
);
""");

    await db.execute("""
CREATE TABLE IF NOT EXISTS `$_tablePetChoices` (
  `$_columnPetChoicesId` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `$_columnPetChoicesPetId` INTEGER NOT NULL,
  `$_columnPetChoicesChoice` INTEGER NOT NULL,
  `$_columnPetChoicesCreatedAt` INTEGER NOT NULL,
  FOREIGN KEY(`$_columnPetChoicesPetId`) REFERENCES `$_tablePets`(`$_columnPetId`) ON UPDATE NO ACTION ON DELETE CASCADE
);
""");

    await db.execute("""
CREATE UNIQUE INDEX `$_indexPetChoicesPetId` ON `$_tablePetChoices` (`$_columnPetChoicesPetId`);
""");

    await db.execute("""
CREATE INDEX `$_indexPetChoicesChoice` ON `$_tablePetChoices` (`$_columnPetChoicesChoice`);
      """);
  }

  Future insertShelters(List<Shelter> shelters) async {
    var batch = (await db).batch();

    shelters.forEach(
      (shelter) => batch.insert(
          _tableShelters,
          {
            _columnShelterId: shelter.id,
            _columnShelterName: shelter.name,
            _columnShelterEmail: shelter.email,
            _columnShelterPhone: shelter.phone,
          },
          conflictAlgorithm: ConflictAlgorithm.replace),
    );

    return await batch.commit(noResult: true);
  }

  Future insertPets(List<Pet> pets, {onConflictReplace: true}) async {
    var shelters = pets.map((p) => p.shelter).toSet().toList(growable: false);
    await this.insertShelters(shelters);

    var batch = (await db).batch();

    pets.forEach(
      (pet) => batch.insert(
            _tablePets,
            {
              _columnPetId: pet.id,
              _columnPetShelterId: pet.shelter.id,
              _columnPetAvailable: pet.available ? 1 : 0,
              _columnPetProfilePhoto: pet.profilePhoto,
              _columnPetName: pet.name,
              _columnPetShortDescription: pet.shortDescription,
              _columnPetDescription: pet.description,
              _columnPetPhotosJson: jsonEncode(
                pet.photos.map((photo) => photo.photo).toList(),
              ),
            },
            conflictAlgorithm: onConflictReplace
                ? ConflictAlgorithm.replace
                : ConflictAlgorithm.ignore,
          ),
    );
    await batch.commit(noResult: true);
  }

  Future insertPetChoice(Pet pet, Decision decision) async {
    var decisionNumber;
    switch (decision) {
      case Decision.nope:
        decisionNumber = _petDecisionNumDislike;
        break;
      case Decision.like:
        decisionNumber = _petDecisionNumLike;
        break;
      case Decision.superLike:
        decisionNumber = _petDecisionNumGetPet;
        break;
      default:
        decisionNumber = null;
    }
    if (decisionNumber != null) {
      (await db).insert(
        _tablePetChoices,
        {
          _columnPetChoicesPetId: pet.id,
          _columnPetChoicesChoice: decisionNumber,
          _columnPetChoicesCreatedAt: DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Shelter _mapToShelter(Map map) {
    return Shelter(
      id: map[_columnShelterId],
      name: map[_columnShelterName],
      email: map[_columnShelterEmail],
      phone: map[_columnShelterPhone],
    );
  }

  Pet _mapToPet(Map map) {
    var photos = (jsonDecode(map[_columnPetPhotosJson]) as List)
        .map((p) => p as String)
        .map<PetPhoto>((p) => PetPhoto(
              photo: p,
            ))
        .toList(growable: false);

    var decisionRaw = map[_columnPetChoicesChoice];
    PetDecision decision;
    switch (decisionRaw) {
      case _petDecisionNumLike:
        decision = PetDecision.like;
        break;
      case _petDecisionNumDislike:
        decision = PetDecision.dislike;
        break;
      case _petDecisionNumGetPet:
        decision = PetDecision.getPet;
        break;
      default:
        decision = null;
    }

    return Pet(
      id: map[_columnPetId],
      name: map[_columnPetName],
      shortDescription: map[_columnPetShortDescription],
      description: map[_columnPetDescription],
      photos: photos,
      profilePhoto: map[_columnPetProfilePhoto],
      shelter: _mapToShelter(map),
      decision: decision,
      available: map[_columnPetAvailable] == 1 ? true : false,
    );
  }

  List<Pet> _mapToPets(List<Map> listOfMaps) {
    return listOfMaps.map((m) => _mapToPet(m)).toList(growable: false);
  }

  Future<List<Pet>> getPetsFavorites() async {
    var petsMap = await (await db).rawQuery(""" 
SELECT 
  $_tablePets.*,
  $_tableShelters.*,
  $_tablePetChoices.*
FROM 
  $_tablePets 
  INNER JOIN $_tableShelters ON $_tablePets.$_columnPetShelterId = $_tableShelters.$_columnShelterId 
  INNER JOIN $_tablePetChoices ON $_tablePets.$_columnPetId = $_tablePetChoices.$_columnPetChoicesPetId 
  AND $_tablePetChoices.$_columnPetChoicesChoice IN (
    $_petDecisionNumLike, $_petDecisionNumGetPet
  )
WHERE $_tablePets.$_columnPetAvailable = 1 
ORDER BY 
  $_tablePetChoices.$_columnPetChoicesCreatedAt DESC;
    """);

    return _mapToPets(petsMap);
  }

  Future<int> deletePet(Pet pet) async {
    return await (await db)
        .delete(_tablePets, where: "$_columnPetId = ?", whereArgs: [pet.id]);
  }

  Future<List<Pet>> getDislikedPetsOrderedByRandom() async {
    var petsMap = await (await db).rawQuery(""" 
SELECT 
  $_tablePets.*,
  $_tableShelters.*,
  $_tablePetChoices.*
FROM 
  $_tablePets 
  INNER JOIN $_tableShelters ON $_tablePets.$_columnPetShelterId = $_tableShelters.$_columnShelterId 
  INNER JOIN $_tablePetChoices ON $_tablePets.$_columnPetId = $_tablePetChoices.$_columnPetChoicesPetId 
  AND $_tablePetChoices.$_columnPetChoicesChoice = $_petDecisionNumDislike
WHERE $_tablePets.$_columnPetAvailable = 1 
ORDER BY RANDOM();
    """);
    return _mapToPets(petsMap);
  }

  Future<List<int>> getFavoritePetIds() async {
    var petsMap = await (await db).rawQuery(""" 
SELECT 
  $_tablePets.$_columnPetId
FROM 
  $_tablePets 
  INNER JOIN $_tablePetChoices ON $_tablePets.$_columnPetId = $_tablePetChoices.$_columnPetChoicesPetId 
  AND $_tablePetChoices.$_columnPetChoicesChoice IN (
    $_petDecisionNumLike, $_petDecisionNumGetPet
  )
    """);

    return petsMap
        .map((map) => map[_columnPetId] as int)
        .toList(growable: false);
  }

  Future<List<int>> getDislikedPetIds() async {
    var petsMap = await (await db).rawQuery(""" 
SELECT 
  $_tablePets.$_columnPetId
FROM 
  $_tablePets 
  INNER JOIN $_tablePetChoices ON $_tablePets.$_columnPetId = $_tablePetChoices.$_columnPetChoicesPetId 
  AND $_tablePetChoices.$_columnPetChoicesChoice = $_petDecisionNumDislike
    """);

    return petsMap
        .map((map) => map[_columnPetId] as int)
        .toList(growable: false);
  }

  Future dispose() async {
    if (_db != null && _db.isOpen) {
      await _db.close();
      _db = null;
    }
  }
}
