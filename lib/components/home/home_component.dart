import 'package:flutter/material.dart';
import 'package:getpet/components/onboarding/onboarding_component.dart';
import 'package:getpet/components/pet_favorites/favorites_component.dart';
import 'package:getpet/components/swipe/pet_swipe_component.dart';
import 'package:getpet/components/user_profile/user_login_component.dart';
import 'package:getpet/localization/app_localization.dart';
import 'package:getpet/preferences/app_preferences.dart';
import 'package:getpet/widgets/getpet_app_bar_image.dart';

class HomeComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const GetPetAppBarTitleImage(),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline),
              tooltip: AppLocalizations.of(context).userGuide,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OnboardingComponent()),
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.account_circle)),
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/ic_home.png",
                    color: Colors.white70,
                  ),
                ),
              ),
              Tab(icon: Icon(Icons.favorite)),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            UserLoginComponent(),
            PetSwipeComponent(),
            FavoritePetsComponent(),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () async {
      final isOnboardingPassed = await AppPreferences().isOnboardingPassed();

      if (!isOnboardingPassed) {
        await AppPreferences().setOnboardingPassed();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OnboardingComponent()),
        );
      }
    });

    return controller;
  }
}
