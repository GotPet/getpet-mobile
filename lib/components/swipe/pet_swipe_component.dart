import 'package:flutter/material.dart';
import 'package:getpet/components/swipe/pet_engine.dart';
import 'package:getpet/components/swipe/swiping_cards.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/components/swipe/pet_card.dart';
import 'package:getpet/widgets/buttons.dart';
import 'package:getpet/widgets/empty_state.dart';
import 'package:getpet/widgets/progress_indicator.dart';
import 'package:swipe_card/swipe_card.dart';

class PetSwipeComponent extends StatefulWidget {
  @override
  _PetSwipeComponentState createState() => _PetSwipeComponentState();
}

class _PetSwipeComponentState extends State<PetSwipeComponent>
    with AutomaticKeepAliveClientMixin {
  final _petsToSwipeFuture = PetsService().getPetsToSwipe();

  PetEngine engine;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: new FutureBuilder(
        future: _petsToSwipeFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            List<Pet> pets = snapshot.data;
            if (pets.isNotEmpty) {
              engine = PetEngine(pets);
              return Column(
                children: [
                  Expanded(
                    child: SwipingCards(
                      engine: engine,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _buildButtonRow(),
                ],
              );
            } else {
              return EmptyStateWidget(
                assetImage: "assets/no_pets.png",
                emptyText:
                    "O ne!\nGyvūnų sąrašas jau baigėsi.\nPatikrink pamėgtų gyvūnų sąrašą!",
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

  @override
  bool get wantKeepAlive => true;

  Widget _buildButtonRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () => engine.notifier.skipCurrent(),
          heroTag: "fab_dislike",
          child: Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: FloatingActionButton(
            onPressed: () {
              if (engine.skipped.isNotEmpty) engine.notifier.undo();
            },
            child: Icon(
              Icons.replay,
              color: Colors.yellow[700],
            ),
            heroTag: "fab_undo",
            mini: true,
          ),
        ),
        FloatingActionButton(
          onPressed: () => engine.notifier.likeCurrent(),
          child: Icon(
            Icons.favorite,
            color: Colors.green,
          ),
          heroTag: "fab_like",
        ),
      ],
    );
  }
}
