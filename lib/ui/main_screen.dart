import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/screens/favourites/favourite_screen.dart';
import 'package:food_it_flutter/ui/screens/profile/profile_screen.dart';
import 'package:food_it_flutter/ui/screens/restaurant/home_screen.dart';
import 'package:food_it_flutter/ui/screens/search/search_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:food_it_flutter/ui/utils/rive_utils.dart';
import 'package:provider/provider.dart';
import 'components/btm_nav_item.dart';
import 'components/rive_models/menu.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  var currentIndex = 0;
  var reverse = false;

  Menu selectedBottomNav = bottomNavItems.first;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottomNav != menu) {
      setState(() {
        selectedBottomNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
            () {
          setState(() {});
        },
      );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var currentUser = authProvider.user;
    var screens = [
      const HomeScreen(),
      const SearchScreen(),
      currentUser != null ? FavouriteScreen(user: currentUser) : Container(),
      currentUser != null ? ProfileScreen(user: currentUser) : Container(),
    ];
    return Scaffold(
      extendBody: true,
      backgroundColor: background,
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 750),
        reverse: reverse,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: screens[currentIndex],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding:
            const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                List.generate(
                  bottomNavItems.length,
                      (index) {
                    Menu navBar = bottomNavItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        RiveUtils.changeSMIBoolState(navBar.rive.status!);
                        updateSelectedBtmNav(navBar);
                        setState(() {
                          reverse = index < currentIndex;
                          currentIndex = index;
                        });
                      },
                      riveOnInit: (artboard) {
                        navBar.rive.status = RiveUtils.getRiveInput(
                            artboard,
                            stateMachineName: navBar.rive.stateMachineName
                        );
                        print(navBar.rive.stateMachineName);
                      },
                      selectedNav: selectedBottomNav,
                    );
                  },
                ),
            ),
          ),
        ),
      ),
    );
  }
}
