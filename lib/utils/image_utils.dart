import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;

int _ceilToHundreds(int size) {
  if (size % 100 != 0) {
    size = size + 100 - (size % 100);
  }

  return size;
}

String getSizedImageUrl(String url, int width,
    {int height, bool ceilToHundreds = false}) {
  if (ceilToHundreds && height != null) {
    throw ArgumentError("Cannot use both ceilToHundreds and height");
  }
  if (ceilToHundreds) {
    width = _ceilToHundreds(width);
  }
  width = min(width, 1500);

  if (height == null || height > 1500) {
    return url.replaceFirst('/media/', '/w-$width/media/');
  }

  return url.replaceFirst('/media/', '/${width}x$height/media/');
}

String getSizedImageUrlFromConstraints(String url, BoxConstraints constraints,
    {bool includeWidth: true, bool includeHeight: true}) {
  if (includeWidth && constraints.maxWidth.isInfinite) {
    developer.log("Unable to get width (${constraints.maxWidth})");
    return url;
  }

  if (includeHeight && constraints.maxHeight.isInfinite) {
    developer.log("Unable to get height (${constraints.maxHeight})");
    return url;
  }

  final width = includeWidth ? constraints.maxWidth.ceil() : null;
  final height = includeHeight ? constraints.maxHeight.ceil() : null;

  return getSizedImageUrl(url, width, height: height);
}
