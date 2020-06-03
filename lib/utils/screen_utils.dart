import 'package:flutter/material.dart';

int getScreenWidth(BuildContext context) {
  return convertLogicalPixelsToPixels(
    context,
    MediaQuery.of(context).size.width,
  );
}

int convertLogicalPixelsToPixels(BuildContext context, double logicalPixels) {
  return (logicalPixels * MediaQuery.of(context).devicePixelRatio).ceil();
}
