import 'package:flutter_test/flutter_test.dart';
import 'package:getpet/utils/image_utils.dart';

void main() {
  group('Getting sized image url', () {
    const IMAGE_URL =
        "https://www.getpet.lt/media/img/web/pet/nida/nida-photo.jpg";

    test('only width', () {
      final url = getSizedImageUrl(IMAGE_URL, 500);

      expect(
        url,
        "https://www.getpet.lt/cdn-cgi/image/width=500,quality=85,fit=cover,f=auto,metadata=none/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

    test('width and height', () {
      final url = getSizedImageUrl(IMAGE_URL, 500, height: 300);

      expect(
        url,
        "https://www.getpet.lt/cdn-cgi/image/width=500,quality=85,fit=cover,f=auto,metadata=none,height=300/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

    test('width and ceil to hundreds', () {
      final url = getSizedImageUrl(IMAGE_URL, 512, ceilToHundreds: true);

      expect(
        url,
        "https://www.getpet.lt/cdn-cgi/image/width=600,quality=85,fit=cover,f=auto,metadata=none/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

  });
}
