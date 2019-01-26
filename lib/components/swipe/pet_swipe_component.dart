import 'package:flutter/material.dart';
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
  final deck = CardsDeck();
  final petsService = PetsService();

  _PetSwipeWidgetState(
    this.pets,
  ) : assert(pets != null);

  // The deck helps manage the cards as they are swiped out.
  int _topCardNumber = 0;

  initState() {
    super.initState();
    deck.addBottom(_createNewCard(0));
    deck.addBottom(_createNewCard(1));
  }

  SwipeCard _createNewCard(int position) {
    if (position < pets.length) {
      final pet = pets[position];
      return new SwipeCard(
        child: PetCard(key: Key("PetCard: ${pet.id}"), pet: pet),
        onSwipe: (int direction) {
          if (direction == SwipeCard.leftSwipe) {
            petsService.dislikePet(pet);
          } else {
            petsService.likePet(pet);
          }
          advanceCard();
        },
        onAnimationDone: () {
          addNewCardToBottom();
        },
      );
    } else {
      return SwipeCard(
        child: EmptyStateWidget(
          assetImage: "assets/no_pets.png",
          emptyText:
              "O ne!\nGyvūnų sąrašas jau baigėsi.\nPatikrink pamėgtų gyvūnų sąrašą!",
        ),
        onSwipe: (int direction) {
          advanceCard();
        },
        onAnimationDone: () {
          addNewCardToBottom();
        },
      );
    }
  }

  advanceCard() {
    setState(() {
      ++_topCardNumber;
    });
  }

  addNewCardToBottom() {
    setState(() {
      deck.addBottom(_createNewCard(_topCardNumber + 1));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: deck.topTwoCards(),
            ),
          ),
          Visibility(
            visible: false,
//            visible: _topCardNumber < pets.length,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RoundIconButton.large(
                    icon: Icons.clear,
                    iconColor: Colors.red,
                    onPressed: () {
//                    _matchEngine.currentMatch.nope();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: new RoundIconButton.small(
                      icon: Icons.refresh,
                      iconColor: Colors.orange,
                      onPressed: () {},
                    ),
                  ),
                  new RoundIconButton.large(
                    icon: Icons.favorite,
                    iconColor: Colors.green,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
