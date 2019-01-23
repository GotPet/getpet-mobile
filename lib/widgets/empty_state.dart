import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String assetImage;
  final String emptyText;

  const EmptyStateWidget(
      {Key key, @required this.assetImage, @required this.emptyText})
      : assert(assetImage != null),
        assert(emptyText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Image(
                image: AssetImage(
                  this.assetImage,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              this.emptyText,
              style: TextStyle(
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
