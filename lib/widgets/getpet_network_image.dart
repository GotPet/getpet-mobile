
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class GetPetNetworkImage extends StatelessWidget {
  final String url;
  final bool useDiskCache;

  const GetPetNetworkImage(
      {Key key, @required this.url, this.useDiskCache: true})
      : assert(url != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransitionToImage(
      image: AdvancedNetworkImage(
        url,
        useDiskCache: useDiskCache,
      ),
      printError: true,
      fit: BoxFit.cover,
      placeholder: Placeholder(color: Theme.of(context).primaryColor,),
      enableRefresh: true,
    );
  }
}
