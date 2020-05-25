import 'package:flutter/material.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/utils/image_utils.dart';
import 'package:getpet/utils/screen_utils.dart';
import 'package:getpet/widgets/getpet_network_image.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({
    Key key,
    @required this.pet,
  })  : assert(pet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final screenWidth = getScreenWidth(context);
                final imageUrl = getSizedImageUrl(
                  pet.profilePhoto,
                  screenWidth,
                  ceilToHundreds: true,
                );

                return Hero(
                  tag: "pet-${pet.id}-photo-image-cover",
                  child: GetPetNetworkImage(
                    url: imageUrl,
                    loadingIndicator: const CircularProgressIndicator(),
                  ),
                );
              },
            ),
            PetCardInformation(
              pet: pet,
              iconData: Icons.info,
            ),
          ],
        ),
      ),
    );
  }
}

class PetCardInformation extends StatelessWidget {
  final Pet pet;
  final IconData iconData;

  const PetCardInformation({
    Key key,
    @required this.pet,
    @required this.iconData,
  })  : assert(pet != null),
        super(key: key);

  // https://github.com/flutter/flutter/issues/12463
  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Hero(
        tag: "pet-${pet.id}-card-information",
        flightShuttleBuilder: _flightShuttleBuilder,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        pet.name,
                        maxLines: 1,
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.0,
                        ),
                      ),
                      Text(
                        pet.shortDescription,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  iconData,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
