import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:getpet/components/shelter_pet/shelter_pet_component.dart';
import 'package:getpet/pets.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:getpet/repositories/pets_db_repository.dart';

class PetProfileComponent extends StatelessWidget {
  final Pet pet;

  PetProfileComponent({
    Key key,
    @required this.pet,
  })  : assert(pet != null),
        super(key: key);

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
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return AlertDialog(
                          title: Text("Pašalinti gyvūną iš sąrašo?"),
                          content: Text(
                              "Šis veiksmas pašalins gyvūną iš gyvūnų sąrašo."),
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
                                "Panaikinti",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () async {
                                print(await PetsDBRepository().deletePet(pet));
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
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
      floatingActionButton: new FloatingActionButton.extended(
        icon: Image.asset(
          "assets/ic_home.png",
          color: Colors.white,
          width: 24,
        ),
        label: Text("GetPet"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ShelterPetComponent(pet: pet)),
            ),
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
    var photos = pet
        .allPhotos()
        .map(
          (photo) => AdvancedNetworkImage(
                photo,
                useDiskCache: true,
              ),
        )
        .toList(growable: false);
    return new Carousel(
      images: photos,
      moveIndicatorFromBottom: 300,
      dotBgColor: Colors.transparent,
    );
  }
}
