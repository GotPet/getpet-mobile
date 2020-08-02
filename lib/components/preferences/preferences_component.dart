
import 'package:flutter/material.dart';
import 'package:getpet/localization/app_localization.dart';

class PreferencesComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: Text(AppLocalizations.of(context).iAmInterested),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: _PetTypeSelectionButton(
                  title: AppLocalizations.of(context).dogs,
                )),
                Expanded(
                    child: _PetTypeSelectionButton(
                  title: AppLocalizations.of(context).cats,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PetTypeSelectionButton extends StatelessWidget {
  final String title;

  const _PetTypeSelectionButton({
    Key key,
    @required this.title,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.white,
        child: AspectRatio(
          aspectRatio: 1,
          child: FlatButton(
            onPressed: () => {},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Icon(Icons.pets, size: 128, color: Colors.black),
                  ),
                  // icon
                  Text(
                    this.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                  // text
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
