import 'package:flutter/material.dart';

class OnboardingStepComponent extends StatelessWidget {
  final String assetName;
  final String title;
  final String description;

  const OnboardingStepComponent({
    Key key,
    @required this.assetName,
    @required this.title,
    @required this.description,
  })  : assert(assetName != null),
        assert(title != null),
        assert(description != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: double.infinity,
      width: double.infinity,
      decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
      child: Stack(
        children: <Widget>[
          new Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(assetName),
                  fit: BoxFit.fitHeight,
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
        alignment: FractionalOffset.center,
      ),
    );
  }
}
