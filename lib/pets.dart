import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'pets.g.dart';

@JsonSerializable()
class Shelter extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;

  Shelter({
    this.id,
    this.name,
    this.email,
    this.phone,
  }) : super([
          id,
          name,
          email,
          phone,
        ]);

  factory Shelter.fromJson(Map<String, dynamic> json) =>
      _$ShelterFromJson(json);

  Map<String, dynamic> toJson() => _$ShelterToJson(this);
}

@JsonSerializable()
class PetPhoto extends Equatable {
  final String photo;

  PetPhoto({
    this.photo,
  }) : super([
          photo,
        ]);

  factory PetPhoto.fromJson(Map<String, dynamic> json) =>
      _$PetPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PetPhotoToJson(this);
}

@JsonSerializable()
class Pet extends Equatable {
  final int id;
  final String name;

  @JsonKey(name: 'is_available')
  final bool available;

  @JsonKey(name: 'short_description')
  final String shortDescription;

  @JsonKey(name: 'photo')
  final String profilePhoto;

  final String description;

  @JsonKey(name: 'profile_photos')
  final List<PetPhoto> photos;

  final Shelter shelter;

  @JsonKey(name: 'pet_type')
  final PetType petType;

  @JsonKey(ignore: true)
  final PetDecision decision;

  Pet({
    @required this.id,
    @required this.name,
    @required this.shortDescription,
    @required this.description,
    @required this.photos,
    @required this.profilePhoto,
    @required this.shelter,
    @required this.available,
    @required this.petType,
    this.decision,
  })  : assert(id != null),
        assert(name != null),
        assert(shortDescription != null),
        assert(description != null),
        assert(photos != null),
        assert(profilePhoto != null),
        assert(shelter != null),
        assert(available != null),
        assert(petType != null),
        super([
          id,
          name,
          shortDescription,
          description,
          photos,
          profilePhoto,
          shelter,
          decision,
          petType,
        ]);

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Map<String, dynamic> toJson() => _$PetToJson(this);

  List<String> allPhotos() {
    var allPhotos = [profilePhoto];
    allPhotos.addAll(photos.map((p) => p.photo));
    return allPhotos;
  }

  bool isInFavorites() {
    if (decision == null || decision == PetDecision.dislike) {
      return false;
    }
    return true;
  }

  bool isStatusGetPet() {
    return decision == PetDecision.getPet;
  }
}

enum PetDecision {
  dislike,
  like,
  getPet,
}

enum PetType {
  @JsonValue("DOG")
  dog,
  @JsonValue("CAT")
  cat,
}

extension PetTypeExtension on PetType {
  String get apiRepresentation {
    switch (this) {
      case PetType.cat:
        return 'CAT';
      case PetType.dog:
        return 'DOG';
      default:
        throw ArgumentError("Unable to map $this to API representation");
    }
  }

  int get dbRepresentation {
    switch (this) {
      case PetType.dog:
        return 1;
      case PetType.cat:
        return 2;
      default:
        throw ArgumentError("Unable to map $this to DB representation");
    }
  }
}
