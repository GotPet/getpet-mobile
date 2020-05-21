import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class GetPetNetworkImage extends StatelessWidget {
  final String url;
  final bool useDiskCache;
  final Widget placeholder;

  const GetPetNetworkImage(
      {Key key, @required this.url, this.placeholder, this.useDiskCache: true})
      : assert(url != null),
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
      ),
      printError: true,
      fit: BoxFit.cover,
      placeholder: placeholder,
      enableRefresh: true,
    );
  }
}
