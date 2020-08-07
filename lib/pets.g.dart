// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shelter _$ShelterFromJson(Map<String, dynamic> json) {
  return Shelter(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$ShelterToJson(Shelter instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };

PetPhoto _$PetPhotoFromJson(Map<String, dynamic> json) {
  return PetPhoto(
    photo: json['photo'] as String,
  );
}

Map<String, dynamic> _$PetPhotoToJson(PetPhoto instance) => <String, dynamic>{
      'photo': instance.photo,
    };

Pet _$PetFromJson(Map<String, dynamic> json) {
  return Pet(
    id: json['id'] as int,
    name: json['name'] as String,
    shortDescription: json['short_description'] as String,
    description: json['description'] as String,
    photos: (json['profile_photos'] as List)
        ?.map((e) =>
            e == null ? null : PetPhoto.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    profilePhoto: json['photo'] as String,
    shelter: json['shelter'] == null
        ? null
        : Shelter.fromJson(json['shelter'] as Map<String, dynamic>),
    available: json['is_available'] as bool,
    petType: _$enumDecodeNullable(_$PetTypeEnumMap, json['pet_type']),
  );
}

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_available': instance.available,
      'short_description': instance.shortDescription,
      'photo': instance.profilePhoto,
      'description': instance.description,
      'profile_photos': instance.photos,
      'shelter': instance.shelter,
      'pet_type': _$PetTypeEnumMap[instance.petType],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PetTypeEnumMap = {
  PetType.dog: 'DOG',
  PetType.cat: 'CAT',
};
