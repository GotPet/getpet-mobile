import 'package:flutter/material.dart';

int getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width.ceil();
}
