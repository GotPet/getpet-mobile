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
  final Dio dio = Dio(Options(
    baseUrl: _baseApiUrl,
  ));

  final _appPreferences = AppPreferences();
  final _authenticationManager = AuthenticationManager();

  PetsApiService._internal() {
    dio.interceptor.request.onSend = (Options options) async {
      final apiToken = await _appPreferences.getApiToken();

      if (apiToken != null) {
        _addHeaderApiToken(options.headers, apiToken);
      } else if (await _authenticationManager.isLoggedIn()) {
        try {
          dio.interceptor.request.lock();
          final idToken = await _authenticationManager.getIdToken();
          if (idToken != null) {
            final apiToken = await _authenticate(idToken);
            await _appPreferences.setApiToken(apiToken);

            _addHeaderApiToken(options.headers, apiToken);
          }
        } catch (ex) {
          print(ex);
        } finally {
          dio.interceptor.request.unlock();
        }
      }

      return options;
    };
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
