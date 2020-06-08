import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:getpet/widgets/getpet_network_image.dart';

class FullScreenImageScreenArguments {
  final String name;
  final List<String> photos;
  final int initialIndex;

  const FullScreenImageScreenArguments(
      this.name, this.photos, this.initialIndex);
}

class FullScreenImageScreen extends StatefulWidget {
  final String name;
  final List<String> photos;
  final int initialIndex;

  const FullScreenImageScreen({
    Key key,
    @required this.name,
    @required this.photos,
    @required this.initialIndex,
  })  : assert(photos != null),
        assert(name != null),
        assert(initialIndex != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FullScreenImageScreenState(
        name: name,
        photos: photos,
        index: initialIndex,
      );
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  String name;
  List<String> photos;
  int index;
  double zoom = 1.0;

  _FullScreenImageScreenState({
    @required this.name,
    @required this.photos,
    @required this.index,
  })  : assert(photos != null),
        assert(name != null),
        assert(index != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name ${index + 1}/${photos.length}"),
      ),
      body: PageView.builder(
        itemCount: photos.length,
        controller: PageController(
          initialPage: index,
          // It's a hack to, but used to load images next image
          viewportFraction: 0.9999999,
        ),
        onPageChanged: (index) => setState(() {
          this.index = index;
        }),
        physics: zoom == 1.0
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) {
          return ZoomableWidget(
            minScale: 1,
            maxScale: 3,
            zoomSteps: 1,
            onZoomChanged: (zoom) => setState(() {
              this.zoom = zoom;
            }),
            child: Container(
              child: GetPetNetworkImage(
                url: photos[position],
              ),
            ),
          );
        },
      ),
    );
  }
}
