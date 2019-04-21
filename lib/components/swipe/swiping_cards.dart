import 'package:flutter/material.dart';
import 'package:getpet/components/pet_profile/pet_profile.dart';
import 'package:getpet/components/swipe/pet_engine.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/widgets/empty_state.dart';

import 'draggable_card.dart';
import 'pet_card.dart';

// Adapter from https://github.com/SpokenBanana/pawdoption/blob/master/lib/widgets/swiping_cards.dart
class SwipingCards extends StatefulWidget {
  SwipingCards({this.engine});

  final PetEngine engine;

  @override
  _SwipingCardsState createState() => _SwipingCardsState();
}

class _SwipingCardsState extends State<SwipingCards>
    with AutomaticKeepAliveClientMixin<SwipingCards> {
  @override
  bool get wantKeepAlive => true;

  double _backCardScale = 0.9;

  final petsService = PetsService();

  @override
  void initState() {
    super.initState();
    widget.engine.notifier.addListener(_onSwipeChange);
  }

  _onSwipeChange() {
    if (widget.engine.notifier.swiped == Swiped.undo) {
      setState(() {
        widget.engine.getRecentlySkipped();
      });
    }
  }

  @override
  void dispose() {
    widget.engine.notifier.removeListener(_onSwipeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.engine.currentList.isEmpty) {
      return EmptyStateWidget(
        assetImage: "assets/no_pets.png",
        emptyText: AppLocalizations.of(context).noMorePetsToSwipe,
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        widget.engine.nextPet == null
            ? SizedBox()
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(_backCardScale, _backCardScale),
                child: PetCard(pet: widget.engine.nextPet),
              ),
        DraggableCard(
          onLeftSwipe: () {
            setState(() {
              var pet = widget.engine.currentPet;
              widget.engine.skip(widget.engine.currentPet);
              petsService.dislikePet(pet);

              widget.engine.removeCurrentPet();
            });
          },
          onRightSwipe: () {
            setState(() {
              var pet = widget.engine.currentPet;
              if (!widget.engine.liked.contains(pet)) {
                widget.engine.liked.add(pet);

                petsService.likePet(pet);
              }
              widget.engine.removeCurrentPet();
            });
          },
          onSwipe: (Offset offset) {
            setState(() {
              _backCardScale =
                  0.9 + (0.1 * (offset.distance / 150)).clamp(0.0, 0.1);
            });
          },
          notifier: widget.engine.notifier,
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PetProfileComponent(
                        pet: widget.engine.currentPet,
                      ),
                ),
              ),
          child: PetCard(
            pet: widget.engine.currentPet,
          ),
        ),
      ],
    );
  }
}
