import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:getpet/components/pet_profile/pet_profile.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/widgets/empty_state.dart';
import 'package:getpet/widgets/progress_indicator.dart';

class FavoritePetsComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Pet>>(
        future: PetsService().getFavoritePets(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          if (snapshot.hasData) {
            var pets = snapshot.data;

            if (pets.isNotEmpty) {
              return ListViewFavoritePets(
                pets: pets,
              );
            } else {
              return EmptyStateWidget(
                assetImage: "assets/no_pets.png",
                emptyText:
                    "Neturite pamėgtų gyvūnų,\nlaikas išssirinkti draugą!",
              );
            }
          } else {
            return Center(
              child: AppProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ListViewFavoritePets extends StatelessWidget {
  final List<Pet> pets;

  ListViewFavoritePets({Key key, this.pets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: pets.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context, position) {
          var pet = pets[position];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => _onTapItem(context, pet),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      key: Key(pet.profilePhoto),
                      backgroundImage: AdvancedNetworkImage(
                        pet.profilePhoto,
                        useDiskCache: true,
                      ),
                      radius: 36,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                            child: Text(
                              pet.name,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            pet.shortDescription,
                            style: new TextStyle(
                              fontSize: 18.0,
                            ),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onTapItem(BuildContext context, Pet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PetProfileComponent(pet: pet)),
    );
  }
}
