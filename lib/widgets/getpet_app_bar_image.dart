import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GetPetAppBarTitleImage extends StatelessWidget {
  const GetPetAppBarTitleImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/get_pet_logo.png',
      fit: BoxFit.cover,
      height: 25,
    );
  }
}
