import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/routes.dart';
import 'package:getpet/utils/image_utils.dart';
import 'package:getpet/utils/screen_utils.dart';
import 'package:getpet/widgets/getpet_network_image.dart';
import 'package:getpet/utils/container_utils.dart';

import 'full_screen_images_component.dart';

class PetPhotosCarousel extends StatelessWidget {
  final Pet pet;

  PetPhotosCarousel({this.pet});

  @override
  Widget build(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    final photos = pet
        .allPhotos()
        .map(
          (photo) => getSizedImageUrl(
            photo,
            screenWidth,
            ceilToHundreds: true,
          ),
        )
        .mapIndexed(_createImageWidget)
        .toList(growable: false);

    return new Carousel(
      images: photos,
      dotPosition: DotPosition.topCenter,
      indicatorBgPadding: 45,
      dotBgColor: Colors.transparent,
      autoplay: false,
      onImageTap: (i) => openPhotoFullscreen(
        context,
        pet.allPhotos(),
        i,
      ),
    );
  }

  Widget _createImageWidget(String url, int index) {
    final image = GetPetNetworkImage(
      url: url,
    );

    if (index == 0) {
      return Hero(
        tag: "pet-${pet.id}-photo-image-cover",
        child: image,
      );
    }

    return image;
  }

  Future openPhotoFullscreen(
      BuildContext context, List<String> photos, int index) async {
    return await Navigator.pushNamed(
      context,
      Routes.ROUTE_FULL_SCREEN_IMAGE,
      arguments: FullScreenImageScreenArguments(pet.name, photos, index),
    );
  }
}
