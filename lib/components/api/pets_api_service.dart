import 'package:getpet/pets.dart';
import 'package:getpet/preferences/app_preferences.dart';
import 'package:dio/dio.dart';

class PetsApiService {
  static final PetsApiService _singleton = new PetsApiService._internal();

  factory PetsApiService() {
    return _singleton;
  }

  final Dio dio = Dio(Options(
    baseUrl: "https://www.getpet.lt/api/",
  ));

  PetsApiService._internal() {
    dio.interceptor.request.onSend = (Options options) async {
      final apiToken = await AppPreferences().getApiToken();

      if (apiToken != null) {
        options.headers["Authorization"] = "Token $apiToken";
      }

      return options;
    };
  }

  Future<String> authenticate(String idToken) async {
    final response = await dio.post(
      '/v1/authentication/firebase/connect/',
      data: {
        "id_token": idToken,
      },
    );

    return response.data['key'];
  }

  Future<List<Pet>> generatePetsToSwipe(
    List<int> favoritePetIds,
    List<int> dislikedPetIds,
  ) async {
    final response = await dio.post(
      '/v1/pets/generate/',
      data: {
        "liked_pets": favoritePetIds,
        "disliked_pets": dislikedPetIds,
      },
    );

    return response.data.map<Pet>((model) => Pet.fromJson(model)).toList();
  }

  Future likePet(Pet pet) async {
    await dio.put(
      '/v1/pets/pet/choice/',
      data: {
        "pet": pet.id,
        "is_favorite": true,
      },
    );
  }

  Future dislikePet(Pet pet) async {
    await dio.put(
      '/v1/pets/pet/choice/',
      data: {
        "pet": pet.id,
        "is_favorite": false,
      },
    );
  }

  Future shelterPet(Pet pet) async {
    await dio.put(
      "/v1/pets/pet/shelter/",
      data: {
        "pet": pet.id,
      },
    );
  }
}
