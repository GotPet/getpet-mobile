import 'package:flutter/material.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/routes.dart';
import 'package:getpet/utils/image_utils.dart';
import 'package:getpet/utils/screen_utils.dart';
import 'package:getpet/widgets/getpet_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'full_screen_images_component.dart';

class PetPhotosCarouselWithIndicator extends StatelessWidget {
  final Pet pet;

  PetPhotosCarouselWithIndicator({this.pet});

  final _pageController = PageController(
    initialPage: 0,
    // It's a hack to, but used to load images next image
    viewportFraction: 0.9999999,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    final allPhotos = pet.allPhotos();

    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: _pageController,
          itemCount: allPhotos.length,
          itemBuilder: (BuildContext context, int index) {
            final photo = allPhotos[index];
            final imageUrl = getSizedImageUrl(
              photo,
              screenWidth,
              ceilToHundreds: true,
            );

            return GestureDetector(
              onTap: () => openPhotoFullscreen(context, allPhotos, index),
              child: _createImageWidget(imageUrl, index),
            );
          },
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: allPhotos.length,
                  effect: ScrollingDotsEffect(
                    spacing: 8.0,
                    radius: 4.0,
                    dotWidth: 20,
                    dotHeight: 5,
                    strokeWidth: 2,

                    dotColor: Colors.white,
                    activeDotColor: Theme.of(context).primaryColor,
                    activeDotScale: 1,
                    activeStrokeWidth: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
