import 'package:flutter/material.dart';

String getSizedImageUrl(String url, int width, int height) {
  return url + "?w=$width&h=$height";
}

String getSizedImageUrlFromConstraints(String url, BoxConstraints constraints) {
  if (constraints.maxWidth.isInfinite || constraints.maxHeight.isInfinite) {
    print(
        "Unable to get width (${constraints.maxWidth}) or height (${constraints.maxHeight})");

    return url;
  }

  final width = constraints.maxWidth.ceil();
  final height = constraints.maxHeight.ceil();

  return getSizedImageUrl(url, width, height);
}
