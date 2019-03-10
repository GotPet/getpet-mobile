import 'package:flutter/material.dart';
import 'package:getpet/components/pet_profile/pet_profile.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/utils/image_utils.dart';
import 'package:getpet/widgets/empty_state.dart';
import 'package:getpet/widgets/label.dart';
import 'package:getpet/widgets/progress_indicator.dart';

class FavoritePetsComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Pet>>(
        stream: PetsService().getFavoritePets(),
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
    List<dynamic> cells = [];

    var shelterPets =
        pets.where((pet) => pet.decision == PetDecision.getPet).toList();
    if (shelterPets.isNotEmpty) {
      cells.add(LabelItem("Mano norai paimti gyvūnus"));
      cells.addAll(shelterPets);
    }

    cells.add(LabelItem("Mano pasirinkti gyvūnai"));
    cells.addAll(pets);

    return ListView.builder(
      itemCount: cells.length,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: (context, position) {
        final cell = cells[position];

        if (cell is Pet) {
          return _PetListCell(key: Key("_PetListCell: ${cell.id}"), pet: cell);
        } else if (cell is LabelItem) {
          return Label(text: cell.text);
        }

        throw UnsupportedError(
            "Unable to build favorite pets with passed cell type");
      },
    );
  }
}

class _PetListCell extends StatelessWidget {
  final Pet pet;

  const _PetListCell({Key key, @required this.pet})
      : assert(pet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: Colors.transparent,
                backgroundImage:
                    NetworkImage(getSizedImageUrl(pet.profilePhoto, 72, 72)),
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
  }

  void _onTapItem(BuildContext context, Pet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PetProfileComponent(pet: pet)),
    );
  }
}
