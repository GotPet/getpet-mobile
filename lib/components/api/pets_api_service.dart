import 'dart:convert';
import 'package:getpet/pets.dart';
import 'package:http/http.dart' as http;

class PetsApiService {
  static final PetsApiService _singleton = new PetsApiService._internal();

  factory PetsApiService() {
    return _singleton;
  }

  PetsApiService._internal();

  Future<String> authenticate(String idToken) async {
    final response = await http.post(
      'https://www.getpet.lt/api/v1/authentication/firebase/connect/',
      body: json.encode(
        {
          "id_token": idToken,
        },
      ),
      headers: {
        'content-type': 'application/json',
        'charset': 'utf-8',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var apiTokenRaw = json.decode(utf8.decode(response.bodyBytes));

      return apiTokenRaw['key'];
    }

    throw response.body;
  }

  Future<List<Pet>> generatePetsToSwipe(
    List<int> favoritePetIds,
    List<int> dislikedPetIds,
  ) async {
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
      return json
          .decode(utf8.decode(response.bodyBytes))
          .map<Pet>((model) => Pet.fromJson(model))
          .toList();
    }
    throw Exception('Failed to load post');
  }
}
