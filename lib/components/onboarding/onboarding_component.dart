import 'package:flutter/material.dart';
import 'package:getpet/analytics/analytics.dart';
import 'package:getpet/components/onboarding/onboarding_step_component.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/preferences/app_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingComponent extends StatefulWidget {
  @override
  _OnboardingComponentState createState() => _OnboardingComponentState();
}

class _OnboardingComponentState extends State<OnboardingComponent> {
  final _controller = new PageController();
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      OnboardingStepComponent(
        assetName: "assets/onboarding/onboarding_one.png",
        title: AppLocalizations.of(context).onboarding1Title,
        description: AppLocalizations.of(context).onboarding1Text,
      ),
      OnboardingStepComponent(
        assetName: "assets/onboarding/onboarding_two.png",
        title: AppLocalizations.of(context).onboarding2Title,
        description: AppLocalizations.of(context).onboarding2Text,
      ),
      OnboardingStepComponent(
        assetName: "assets/onboarding/onboarding_three.png",
        title: AppLocalizations.of(context).onboarding3Title,
        description: AppLocalizations.of(context).onboarding3Text,
      ),
      OnboardingStepComponent(
        assetName: "assets/onboarding/onboarding_four.png",
        title: AppLocalizations.of(context).onboarding4Title,
        description: AppLocalizations.of(context).onboarding4Text,
      ),
      OnboardingStepComponent(
        assetName: "assets/onboarding/onboarding_five.png",
        title: AppLocalizations.of(context).onboarding5Title,
        description: AppLocalizations.of(context).onboarding5Text,
      ),
    ];

    bool isDone = page == pages.length - 1;
    return new Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return pages[index % pages.length];
                },
                onPageChanged: (int p) {
                  setState(() {
                    page = p;
                  });
                },
              ),
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  primary: false,
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        isDone
                            ? AppLocalizations.of(context)
                                .onboardingFinish
                                .toUpperCase()
                            : AppLocalizations.of(context)
                                .onboardingNext
                                .toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => advancePageOrFinish(isDone),
                    )
                  ],
                ),
              ),
            ),
            new Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8),
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: pages.length,
                        effect: ScaleEffect(
                          dotColor: Colors.white,
                          activeDotColor: Colors.white,
                          scale: 2,
                          dotWidth: 8,
                          dotHeight: 8,
                          radius: 8
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
                          child: new Material(
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
              ),
            ),
          ],
        ));
  }

  advancePageOrFinish(bool isDone) async {
    if (isDone) {
      await Analytics().logOnboardingComplete();
      await AppPreferences().setOnboardingPassed();
      Navigator.pop(context);
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
