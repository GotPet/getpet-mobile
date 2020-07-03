

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

  var options = 'width=$width,quality=85,fit=cover,f=auto,metadata=none';

  if (height != null) {
    options += ',height=$height';
  }

  return url.replaceFirst('/media/', '/cdn-cgi/image/$options/media/');
}
