import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/rive_models/menu.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';


import '../../domain/user/user.dart';
import '../main_screen.dart';
import '../screens/favourites/favourite_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/restaurant/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.press, required this.currentIndex});

  @override
  State<SideBar> createState() => _SideBarState();

  final VoidCallback press;
  final int currentIndex;
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoCard(
                name: "Abu Anwar",
                bio: "YouTuber",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus
                  .map((menu) => SideMenu(
                menu: menu,
                selectedMenu: selectedSideMenu,
                press: () async {
                  RiveUtils.changeSMIBoolState(menu.rive.status!);
                  setState(() {
                    selectedSideMenu = menu;
                  });
                  var index = sidebarMenus.indexOf(menu);
                  await Future.delayed(Duration(milliseconds: 800));
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1500),
                      pageBuilder: (_, __, ___) => MainScreen(sideBarIndex: index),
                    ),
                  );
                },
                riveOnInit: (artboard) {
                  menu.rive.status = RiveUtils.getRiveInput(artboard,
                      stateMachineName: menu.rive.stateMachineName);
                },
              ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "History".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

