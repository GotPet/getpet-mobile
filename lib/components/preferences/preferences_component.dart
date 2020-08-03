import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getpet/localization/app_localization.dart';

class PreferencesComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: Text(AppLocalizations.of(context).iAmInterested),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    assetName: "assets/dog.png",
                  ),
                ),
                Expanded(
                  child: _PetTypeSelectionButton(
                    title: AppLocalizations.of(context).cats,
                    assetName: "assets/cat.png",
                  ),
                ),
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
  final String assetName;

  const _PetTypeSelectionButton({
    Key key,
    @required this.title,
    @required this.assetName,
  })  : assert(title != null),
        assert(assetName != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: new Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(30.0),
            border: Border.all(color: Colors.white, width: 1.0),
            color: Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(30.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: MaterialButton(
                onPressed: () => {},
                highlightColor: Colors.white30,
                splashColor: Colors.white30,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            this.assetName,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // icon
                      Text(
                        this.title.toUpperCase(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      // text
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
