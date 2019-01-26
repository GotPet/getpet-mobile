import 'package:flutter/material.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/components/swipe/cards.dart';
import 'package:getpet/components/swipe/matches.dart';
import 'package:getpet/widgets/buttons.dart';
import 'package:getpet/widgets/empty_state.dart';
import 'package:getpet/widgets/progress_indicator.dart';

class PetSwipeComponent extends StatefulWidget {
  @override
  _PetSwipeComponentState createState() => _PetSwipeComponentState();
}

class _PetSwipeComponentState extends State<PetSwipeComponent>
    with AutomaticKeepAliveClientMixin {
  final _petsToSwipeFuture = PetsService().getPetsToSwipe();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: new FutureBuilder(
        future: _petsToSwipeFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          if (snapshot.hasData) {
            List<Pet> pets = snapshot.data;
            if (pets.isNotEmpty) {
              return PetSwipeWidget(
                pets: pets,
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
}

class PetSwipeWidget extends StatefulWidget {
  final List<Pet> pets;

  PetSwipeWidget({
    Key key,
    this.pets,
  })  : assert(pets != null),
        super(key: key);

  @override
  _PetSwipeWidgetState createState() {
    return _PetSwipeWidgetState(pets);
  }
}

class _PetSwipeWidgetState extends State<PetSwipeWidget> {
  final List<Pet> pets;
  MatchEngine _matchEngine;

  _PetSwipeWidgetState(
    this.pets,
  ) {
    if (_matchEngine == null) {
      _matchEngine = new MatchEngine(
        matches: pets.map((p) => PetMatch(pet: p)).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: CardStack(
              matchEngine: _matchEngine,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RoundIconButton.large(
                  icon: Icons.clear,
                  iconColor: Colors.red,
                  onPressed: () {
                    _matchEngine.currentMatch.nope();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: new RoundIconButton.small(
                    icon: Icons.refresh,
                    iconColor: Colors.orange,
                    onPressed: () {
                      // TODO:
                    },
                  ),
                ),
                new RoundIconButton.large(
                  icon: Icons.favorite,
                  iconColor: Colors.green,
                  onPressed: () {
                    _matchEngine.currentMatch.like();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
