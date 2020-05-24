import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:getpet/authentication/authentication_manager.dart';
import 'package:getpet/components/shelter_pet/shelter_pet_component.dart';
import 'package:getpet/components/swipe/pet_card.dart';
import 'package:getpet/components/user_profile/user_login_component.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/utils/image_utils.dart';
import 'package:getpet/utils/screen_utils.dart';
import 'package:getpet/widgets/getpet_network_image.dart';
import 'package:getpet/utils/container_utils.dart';
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
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShelterPetComponent(pet: pet)),
    );
  }

  Future launchUserLoginComponent(BuildContext context) async {
    final isLoggedIn = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => UserLoginFullscreenComponent(
                popOnLoginIn: true,
              )),
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
            pinned: true,
            snap: true,
            floating: true,
            title: Text(pet.name),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  PetPhotosCarousel(
                    pet: pet,
                  ),
                  PetCardInformation(
                    pet: pet,
                    showInfoIcon: false,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Visibility(
                visible: pet.isInFavorites(),
                child: Padding(
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
                              AppLocalizations.of(context)
                                  .petRemoveDialogMessage,
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text(
                                  AppLocalizations.of(context)
                                      .petRemoveDialogCancel,
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
                                  AppLocalizations.of(context)
                                      .petRemoveDialogOk,
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
                      top: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      AppLocalizations.of(context).myStory,
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
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              TooltipWithArrow(
                message: AppLocalizations.of(context).readyForDate,
              ),
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

class PetPhotosCarousel extends StatelessWidget {
  final Pet pet;

  PetPhotosCarousel({this.pet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final screenWidth = getScreenWidth(context);

        final photos = pet
            .allPhotos()
            .map(
              (photo) => getSizedImageUrl(
                photo,
                screenWidth,
                ceilToHundreds: true,
              ),
            )
            .mapIndexed(_createImageWidget)
            .toList(growable: false);

        return new Carousel(
          images: photos,
          dotPosition: DotPosition.topCenter,
          indicatorBgPadding: 45,
          overlayShadow: true,
          dotBgColor: Colors.transparent,
          autoplay: false,
        );
      },
    );
  }

  Widget _createImageWidget(String url, int index) {
    final image = GetPetNetworkImage(
      url: url,
    );

    if (index == 0) {
      return Hero(
        tag: "pet-${pet.id}-photo-image-cover",
        child: image,
      );
    }

    return image;
  }
}
