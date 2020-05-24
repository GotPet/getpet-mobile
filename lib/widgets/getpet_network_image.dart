import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:getpet/widgets/progress_indicator.dart';

class GetPetNetworkImage extends StatelessWidget {
  final String url;
  final bool useDiskCache;
  final Widget placeholder;
  final Widget loadingIndicator;

  const GetPetNetworkImage({
    Key key,
    @required this.url,
    this.placeholder,
    this.loadingIndicator: const AppProgressIndicator(),
    this.useDiskCache: false,
  })  : assert(url != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var placeholder = this.placeholder;
    if (placeholder == null) {
      placeholder = Placeholder(color: Theme.of(context).primaryColor);
    }

    return TransitionToImage(
      image: AdvancedNetworkImage(
        url,
        useDiskCache: useDiskCache,
        header: {
          'accept': 'image/webp,image/*;q=0.8',
          'sec-fetch-dest': 'image',
        },
      ),
      printError: true,
      fit: BoxFit.cover,
      placeholder: placeholder,
      enableRefresh: true,
      loadingWidget: Center(child: loadingIndicator),
    );
  }
}
