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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              assetName,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
