import 'package:flutter/material.dart';
import 'package:getpet/components/pet_profile/pet_profile.dart';
import 'package:getpet/pets.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({
    Key key,
    @required this.pet,
  })  : assert(pet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              pet.profilePhoto,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: new Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            pet.name,
                            style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                            ),
                          ),
                          new Text(
                            pet.shortDescription,
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PetProfileComponent(pet: pet)),
          ),
    );
  }
}
