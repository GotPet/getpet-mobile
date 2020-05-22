import 'package:flutter/material.dart';
import 'package:getpet/analytics/analytics.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:getpet/utils/image_utils.dart';
import 'package:getpet/utils/screen_utils.dart';
import 'package:getpet/widgets/getpet_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ShelterPetComponent extends StatelessWidget {
  final Pet pet;

  const ShelterPetComponent({
    Key key,
    @required this.pet,
  })  : assert(pet != null),
        super(key: key);

  Future callShelter(BuildContext context) async {
    var url = 'tel:${pet.shelter.phone}';
    if (await canLaunch(url)) {
      await Analytics().logShelterCall(pet);

      return await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).errorUnableToCallShelter,
          ),
        ),
      );
    }
  }

  Future emailShelter(BuildContext context) async {
    var url = 'mailto:${pet.shelter.email}';
    if (await canLaunch(url)) {
      await Analytics().logShelterEmail(pet);
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).errorUnableToEmailShelter,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    PetsService().shelterPet(pet);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/get_pet_logo.png',
          fit: BoxFit.cover,
          height: 30,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            final screenWidth = getScreenWidth(context);
            final imageUrl = getSizedImageUrl(
              pet.profilePhoto,
              screenWidth,
              ceilToHundreds: true,
            );

            return Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 160,
                            height: 160,
                            child: Hero(
                              tag: "pet-${pet.id}-photo-image-cover",
                              child: GetPetNetworkImage(
                                url: imageUrl,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          pet.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          pet.shortDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          pet.shelter.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).pushAndContact,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            pet.shelter.phone,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        onTap: () async {
                          await callShelter(context);
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            pet.shelter.email,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        onTap: () async {
                          await emailShelter(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            icon: Icon(Icons.phone_in_talk),
            label: Text(AppLocalizations.of(context).callShelter),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            onPressed: () async {
              await callShelter(context);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
