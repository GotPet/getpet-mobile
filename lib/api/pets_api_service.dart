import 'package:dio_firebase_performance/dio_firebase_performance.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/preferences/app_preferences.dart';
import 'package:dio/dio.dart';

class PetsApiService {
  static final PetsApiService _singleton = new PetsApiService._internal();

  factory PetsApiService() {
    return _singleton;
  }

  static const _baseApiUrl = "https://www.getpet.lt/api/";

  static const _authenticateUrl =
      "https://www.getpet.lt/api/v1/authentication/firebase/connect/";

  final Dio rawDio = Dio();
  final Dio dio = Dio(BaseOptions(
    baseUrl: _baseApiUrl,
  ));

  final _appPreferences = AppPreferences();
  final _authenticationManager = AuthenticationManager();

  PetsApiService._internal() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      final apiToken = await _appPreferences.getApiToken();

      if (apiToken != null) {
        _addHeaderApiToken(options.headers, apiToken);
      } else if (await _authenticationManager.isLoggedIn()) {
        try {
          dio.interceptors.requestLock.lock();
          final idToken = await _authenticationManager.getIdToken();
          if (idToken != null) {
            final apiToken = await _authenticate(idToken);
            await _appPreferences.setApiToken(apiToken);

            _addHeaderApiToken(options.headers, apiToken);
          }
        } catch (ex) {
          print(ex);
        } finally {
          dio.interceptors.requestLock.unlock();
        }
      }

      return options;
    }, onResponse: (Response response) {
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      // Do something with response error
      return e; //continue
    }));

    dio.interceptors.add(DioFirebasePerformanceInterceptor());
    rawDio.interceptors.add(DioFirebasePerformanceInterceptor());
  }

  static _addHeaderApiToken(Map<String, dynamic> headers, String apiToken) {
    headers["Authorization"] = "Token $apiToken";
  }

  Future<String> _authenticate(String idToken) async {
    final response = await rawDio.post(
      _authenticateUrl,
      data: {
        "id_token": idToken,
      },
    );

    return response.data['key'];
  }

  Future<List<Pet>> generatePetsToSwipe(
    List<int> favoritePetIds,
    List<int> dislikedPetIds,
    PetType petType,
  ) async {
    final response = await dio.post(
      '/v1/pets/generate/',
      data: {
        "liked_pets": favoritePetIds,
        "disliked_pets": dislikedPetIds,
        "pet_type": petType.index,
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

  Future<List<Pet>> getPets(
      List<int> petIds, String lastUpdateDateIso8601) async {
    if (petIds.isEmpty) {
      return [];
    }

    var petsUrl = "/v1/pets/";
    final queryParams = {
      "pet_ids": petIds.join(','),
      "last_update": lastUpdateDateIso8601,
    };

    List<Pet> allPets = [];
    while (petsUrl != null) {
      final response = allPets.isEmpty
          ? await dio.get(petsUrl, queryParameters: queryParams)
          : await dio.get(petsUrl);

      final pets =
          response.data['results'].map<Pet>((model) => Pet.fromJson(model));

      allPets.addAll(pets);

      petsUrl = response.data['next'];
    }

    return allPets;
  }
}
