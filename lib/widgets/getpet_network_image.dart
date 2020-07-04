import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:getpet/widgets/progress_indicator.dart';

class GetPetNetworkImage extends StatelessWidget {
  final String url;
  final String fallbackAssetImage;
  final bool useDiskCache;
  final bool showLoadingIndicator;
  final Color color;

  const GetPetNetworkImage({
    Key key,
    @required this.url,
    this.color,
    this.fallbackAssetImage,
    this.useDiskCache: false,
    this.showLoadingIndicator = true,
  })  : assert(url != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransitionToImage(
      image: AdvancedNetworkImage(
        url,
        useDiskCache: this.useDiskCache,
        fallbackAssetImage: this.fallbackAssetImage,
        header: {
          'accept': 'image/webp,image/*;q=0.85',
          'sec-fetch-dest': 'image',
        },
      ),
      printError: true,
      fit: BoxFit.cover,
      placeholder: Icon(
        Icons.error_outline,
        color: this.color,
      ),
      enableRefresh: true,
      loadingWidget: this.showLoadingIndicator
          ? Center(
              child: AppProgressIndicator(
                color: this.color,
              ),
            )
          : SizedBox(),
    );
  }
}
