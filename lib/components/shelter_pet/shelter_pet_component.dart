import 'package:flutter/material.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/pets_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ShelterPetComponent extends StatelessWidget {
  final Pet pet;

  const ShelterPetComponent({
    Key key,
    @required this.pet,
  })  : assert(pet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    PetsService().shelterPet(pet);

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            pet.profilePhoto,
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
                    Text(
                      pet.shortDescription,
                      style: TextStyle(
                        fontSize: 16,
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
                        var url = 'tel:${pet.shelter.phone}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)
                                    .errorUnableToCallShelter,
                              ),
                            ),
                          );
                        }
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
                        var url = 'mailto:${pet.shelter.email}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)
                                    .errorUnableToEmailShelter,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            icon: Icon(Icons.phone_in_talk),
            label: Text(AppLocalizations.of(context).callShelter),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            onPressed: () async {
              var url = 'tel:${pet.shelter.phone}';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).errorUnableToCallShelter,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
