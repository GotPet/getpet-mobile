import 'package:flutter/material.dart';
import 'package:getpet/components/onboarding/onboarding_step_component.dart';
import 'package:getpet/preferences/app_preferences.dart';
import 'package:getpet/widgets/dots_indicator.dart';

class _OnboardingComponentState extends State<OnboardingComponent> {
  final _controller = new PageController();
  final List<Widget> _pages = [
    OnboardingStepComponent(
      assetName: "assets/onboarding/onboarding_one.png",
      title: "Labas!",
      description: "Nori būti mūsų draugas?\nSusipažink su programėle!",
    ),
    OnboardingStepComponent(
      assetName: "assets/onboarding/onboarding_two.png",
      title: "Jei susižavėjai,",
      description:
          "nuslink patikusio gyvūno\nnuotrauką dešinėn - taip pridėsi\nją į mėgiamiausių sąrašą.",
    ),
    OnboardingStepComponent(
      assetName: "assets/onboarding/onboarding_three.png",
      title: "Deja, ne šį kartą?",
      description: "Jei nesusižavėjai,\nnuslink nuotrauką kairėn.",
    ),
    OnboardingStepComponent(
      assetName: "assets/onboarding/onboarding_four.png",
      title: "Susipažinkim!",
      description: "Paspausk ant gyvūno nuotraukos\nir perskaityk jo istoriją.",
    ),
    OnboardingStepComponent(
      assetName: "assets/onboarding/onboarding_five.png",
      title: "Priglausk!",
      description: "Paspausk „GetPet“ ir sužinok,\nkur rasi savo draugą.",
    ),
  ];
  int page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = page == _pages.length - 1;
    return new Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
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
                        isDone ? 'PABAIGTI' : 'KITAS',
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
                      child: new DotsIndicator(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageSelected: (int page) {
                          _controller.animateToPage(
                            page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
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
                                isDone ? 'PABAIGTI' : 'KITAS',
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
      await AppPreferences().setOnboardingPassed();
      Navigator.pop(context);
    } else {
      _controller.animateToPage(page + 1,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }
}

class OnboardingComponent extends StatefulWidget {
  @override
  _OnboardingComponentState createState() => _OnboardingComponentState();
}
