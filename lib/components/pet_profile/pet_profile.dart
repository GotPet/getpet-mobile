import 'package:flutter/material.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/components/pet_profile/pet_photos_carousel.dart';
import 'package:getpet/components/swipe/pet_card.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/routes.dart';
import 'package:getpet/widgets/tooptip_with_arrow.dart';

class PetProfileComponent extends StatelessWidget {
  final petsService = PetsService();

  final Pet pet;

  PetProfileComponent({
    Key key,
    @required this.pet,
  })  : assert(pet != null),
        super(key: key);

  final _authenticationManager = AuthenticationManager();

  Future launchShelterPetComponent(BuildContext context) async {
    return await Navigator.pushNamed(
      context,
      Routes.ROUTE_SHELTER_PET,
      arguments: pet,
    );
  }

  Future launchUserLoginComponent(BuildContext context) async {
    final isLoggedIn = await Navigator.pushNamed(
      context,
      Routes.ROUTE_SHELTER_PET,
      arguments: pet,
    );

    if (isLoggedIn == true) {
      await launchShelterPetComponent(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  PetPhotosCarouselWithIndicator(
                    pet: pet,
                  ),
                  PetCardInformation(
                    pet: pet,
                    iconData: Icons.zoom_out_map,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Visibility(
                visible: pet.isInFavorites(),
                child: DislikePetActionWidget(
                  pet: pet,
                  petsService: petsService,
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            fillOverscroll: true,
            hasScrollBody: false,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 160,
                ),
                child: Text(
                  pet.description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              if (!pet.isStatusGetPet()) ToolTipWithArrowForGetPetButton(),
              FloatingActionButton.extended(
                icon: Image.asset(
                  "assets/ic_home.png",
                  color: Colors.white,
                  width: 24,
                ),
                label: Text(AppLocalizations.of(context).appTitle),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                onPressed: () async {
                  if (await _authenticationManager.isLoggedIn()) {
                    await launchShelterPetComponent(context);
                  } else {
                    await launchUserLoginComponent(context);
                  }
                },
              ),
            ],
          ),
        ),
        visible: pet.isInFavorites(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


class DislikePetActionWidget extends StatelessWidget {
  final Pet pet;
  final PetsService petsService;

  const DislikePetActionWidget({
    Key key,
    @required this.pet,
    @required this.petsService,
  })  : assert(pet != null),
        assert(petsService != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context).petRemoveDialogTitle,
                ),
                content: Text(
                  AppLocalizations.of(context).petRemoveDialogMessage,
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      AppLocalizations.of(context).petRemoveDialogCancel,
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
                      AppLocalizations.of(context).petRemoveDialogOk,
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
            },
          );
        },
      ),
    );
  }
}

class ToolTipWithArrowForGetPetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 5)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: Duration(seconds: 2),
          child: TooltipWithArrow(
            message: AppLocalizations.of(context).readyForDate,
          ),
        );
      },
    );
  }
}
