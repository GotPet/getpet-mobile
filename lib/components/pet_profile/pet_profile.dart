import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/components/shelter_pet/shelter_pet_component.dart';
import 'package:getpet/components/user_profile/user_login_component.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/utils/image_utils.dart';

class PetProfileComponent extends StatelessWidget {
  final petsService = PetsService();

  final Pet pet;

  PetProfileComponent({
    Key key,
    @required this.pet,
  })  : assert(pet != null),
        super(key: key);

  final _authenticationManager = AuthenticationManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            primary: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(pet.name),
              centerTitle: false,
              background: PetPhotosCarousel(
                pet: pet,
              ),
            ),
            actions: <Widget>[
              Visibility(
                visible: pet.isInFavorites(),
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return AlertDialog(
                            title: Text("Ištrinti gyvūną iš sąrašo?"),
                            content: Text(
                                "Šis veiksmas ištrins gyvūną iš favoritų sąrašo."),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text(
                                  "Atšaukti",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              new FlatButton(
                                child: new Text(
                                  "Ištrinti",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () async {
                                  await petsService.dislikePet(pet);
                                  final navigator = Navigator.of(context);
                                  navigator.pop();
                                  navigator.pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      pet.shortDescription,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      "MANO ISTORIJA",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      pet.description,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        child: new FloatingActionButton.extended(
          icon: Image.asset(
            "assets/ic_home.png",
            color: Colors.white,
            width: 24,
          ),
          label: Text("GetPet"),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onPressed: () async {
            if (await _authenticationManager.isLoggedIn()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ShelterPetComponent(pet: pet)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserLoginFullscreenComponent()),
              );
            }
          },
        ),
        visible: pet.isInFavorites(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PetPhotosCarousel extends StatelessWidget {
  final Pet pet;

  PetPhotosCarousel({this.pet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final photos = pet
            .allPhotos()
            .map((photo) => NetworkImage(
                  getSizedImageUrlFromConstraints(
                    photo,
                    constraints,
                  ),
                ))
            .toList(growable: false);

        return new Carousel(
          images: photos,
          moveIndicatorFromBottom: 300,
          dotBgColor: Colors.transparent,
          autoplay: false,
        );
      },
    );
  }
}
