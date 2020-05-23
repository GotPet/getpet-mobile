import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:getpet/components/swipe/pet_engine.dart';
import 'package:getpet/components/swipe/swiping_cards.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/widgets/empty_state.dart';
import 'package:getpet/widgets/error_state.dart';
import 'package:getpet/widgets/progress_indicator.dart';

class PetSwipeComponent extends StatefulWidget {
  @override
  _PetSwipeComponentState createState() => _PetSwipeComponentState();
}

class _PetSwipeComponentState extends State<PetSwipeComponent>
    with AutomaticKeepAliveClientMixin {
  AsyncMemoizer _memoizer = AsyncMemoizer();

  PetEngine engine;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: new FutureBuilder(
        future: _fetchPetsToSwipe(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: AppProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);

            return ErrorStateWidget(
              errorText: AppLocalizations.of(context).errorLoadingPets,
              retryCallback: () => setState(() {
                _memoizer = AsyncMemoizer();
              }),
            );
          }

          if (snapshot.hasData) {
            List<Pet> pets = snapshot.data;
            if (pets.isNotEmpty) {
              engine = PetEngine(pets);
              return Column(
                children: [
                  Expanded(
                    child: SwipingCards(
                      key: ValueKey("SwipingCards: ${engine.hashCode}"),
                      engine: engine,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _buildButtonRow(),
                ],
              );
            }
          }

          return EmptyStateWidget(
            assetImage: "assets/no_pets.png",
            emptyText: AppLocalizations.of(context).noMorePetsToSwipe,
          );
        },
      ),
    );
  }

  _fetchPetsToSwipe() async {
    return this._memoizer.runOnce(() async {
      return await PetsService().getPetsToSwipe();
    });
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
