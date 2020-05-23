import 'package:flutter/material.dart';
import 'package:getpet/localization/app_localization.dart';

class ErrorStateWidget extends StatelessWidget {
  final String errorText;
  final VoidCallback retryCallback;

  const ErrorStateWidget({
    Key key,
    @required this.errorText,
    @required this.retryCallback,
  })  : assert(errorText != null),
        assert(retryCallback != null),
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
              child: Image.asset("assets/no_pets.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              this.errorText,
              style: TextStyle(
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.refresh),
            onPressed: retryCallback,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            label: Text(
              AppLocalizations.of(context).retryOnError,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
