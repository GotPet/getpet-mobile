import 'package:flutter/material.dart';
import 'package:getpet/components/home/home_component.dart';
import 'package:getpet/repositories/pets_db_repository.dart';

class AppComponent extends StatefulWidget {
  @override
  _AppComponentState createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> {
  @override
  Future deactivate() async {
    await PetsDBRepository().dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GetPet",
      home: HomeComponent(),
      theme: ThemeData(
        primaryColor: Color.fromARGB(0xFF, 0xDD, 0x61, 0x72),
        primaryColorDark: Color.fromARGB(0xFF, 0x93, 0x1F, 0x33),
        accentColor: Colors.white,
        textTheme: TextTheme(
          body1: TextStyle(
              fontSize: 14.0, color: Color.fromARGB(0xFF, 0x66, 0x66, 0x66)),
        ),
      ),
    );
  }
}
