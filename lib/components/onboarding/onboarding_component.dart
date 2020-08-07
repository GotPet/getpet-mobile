import 'package:flutter/material.dart';
import 'package:getpet/analytics/analytics.dart';
import 'package:getpet/components/onboarding/onboarding_step_component.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/pets.dart';
import 'package:getpet/preferences/app_preferences.dart';
import 'package:getpet/routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingComponent extends StatefulWidget {
  @override
  _OnboardingComponentState createState() => _OnboardingComponentState();
}

class _OnboardingComponentState extends State<OnboardingComponent> {
  static const STEPS_COUNT = 5;
  final _controller = new PageController(viewportFraction: 0.9999999);
  int page = 0;

  @override
  Widget build(BuildContext context) {
    bool isDone = page == (STEPS_COUNT - 1);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () => {advancePageOrFinish(true, skippedOnboarding: true)},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              isDone
                  ? AppLocalizations.of(context).onboardingFinish.toUpperCase()
                  : AppLocalizations.of(context).onboardingNext.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => advancePageOrFinish(isDone),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: new PageView.builder(
              controller: _controller,
              itemCount: STEPS_COUNT,
              itemBuilder: (BuildContext context, int index) {
                switch (index) {
                  case 0:
                    return OnboardingStepComponent(
                      assetName: "assets/onboarding/onboarding_one.png",
                      title: AppLocalizations.of(context).onboarding1Title,
                      description: AppLocalizations.of(context).onboarding1Text,
                    );
                  case 1:
                    return OnboardingStepComponent(
                      assetName: "assets/onboarding/onboarding_two.png",
                      title: AppLocalizations.of(context).onboarding2Title,
                      description: AppLocalizations.of(context).onboarding2Text,
                    );
                  case 2:
                    return OnboardingStepComponent(
                      assetName: "assets/onboarding/onboarding_three.png",
                      title: AppLocalizations.of(context).onboarding3Title,
                      description: AppLocalizations.of(context).onboarding3Text,
                    );
                  case 3:
                    return OnboardingStepComponent(
                      assetName: "assets/onboarding/onboarding_four.png",
                      title: AppLocalizations.of(context).onboarding4Title,
                      description: AppLocalizations.of(context).onboarding4Text,
                    );
                  case 4:
                    return OnboardingStepComponent(
                      assetName: "assets/onboarding/onboarding_five.png",
                      title: AppLocalizations.of(context).onboarding5Title,
                      description: AppLocalizations.of(context).onboarding5Text,
                    );
                  default:
                    throw ArgumentError("Illegal index $index");
                }
              },
              onPageChanged: (int p) {
                setState(() {
                  page = p;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SmoothPageIndicator(
              controller: _controller,
              count: STEPS_COUNT,
              effect: ScaleEffect(
                dotColor: Colors.white,
                activeDotColor: Colors.white,
                scale: 2,
                dotWidth: 8,
                dotHeight: 8,
                radius: 8,
              ),
            ),
          ),
          Padding(
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
                  child: MaterialButton(
                    child: Text(
                      isDone
                          ? AppLocalizations.of(context)
                              .onboardingFinish
                              .toUpperCase()
                          : AppLocalizations.of(context)
                              .onboardingNext
                              .toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      advancePageOrFinish(isDone);
                    },
                    highlightColor: Colors.white30,
                    splashColor: Colors.white30,
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  advancePageOrFinish(bool isDone, {skippedOnboarding: false}) async {
    if (isDone) {
      await AppPreferences().setOnboardingPassed();

      if (skippedOnboarding) {
        await Analytics().logOnboardingSkipped();
      } else {
        await Analytics().logOnboardingComplete();
      }

      final selectedPetType = await AppPreferences().getSelectedPetType();

      if (selectedPetType != null) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(
          context,
          Routes.ROUTE_PREFERENCES,
        );
      }
    } else {
      _controller.animateToPage(page + 1,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  void initState() {
    super.initState();

    Analytics().logOnboardingBegin();
  }
}
