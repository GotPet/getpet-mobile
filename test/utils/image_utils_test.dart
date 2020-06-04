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
        "https://www.getpet.lt/w-500/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

    test('width and height', () {
      final url = getSizedImageUrl(IMAGE_URL, 500, height: 300);

      expect(
        url,
        "https://www.getpet.lt/500x300/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

    test('width and ceil to hundreds', () {
      final url = getSizedImageUrl(IMAGE_URL, 512, ceilToHundreds: true);

      expect(
        url,
        "https://www.getpet.lt/w-600/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

    test('width higher than maximum', () {
      final url = getSizedImageUrl(IMAGE_URL, 2500);

      expect(
        url,
        "https://www.getpet.lt/w-2000/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

    test('width equal to maximum and ceil to hundreds', () {
      final url = getSizedImageUrl(IMAGE_URL, 2000, ceilToHundreds: true);

      expect(
        url,
        "https://www.getpet.lt/w-2000/media/img/web/pet/nida/nida-photo.jpg",
      );
    });

    test('height higher than maximum', () {
      final url = getSizedImageUrl(IMAGE_URL, 1000, height: 2500);

      expect(
        url,
        "https://www.getpet.lt/w-1000/media/img/web/pet/nida/nida-photo.jpg",
      );
    });
  });
}
