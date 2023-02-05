import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

import '../../../data/exceptions/logged_out_exception.dart';
import '../../main_screen.dart';
import '../../theme/colors.dart';
import '../restaurant/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Duration duration = Duration(seconds: 1);

  double logoLeft = -200;
  double opacity = 0;



  void animateItems(BuildContext context) async {
    var size = MediaQuery.of(context).size;
    setState((){
      logoLeft = size.width;
    });
    await Future.delayed(duration);
    await Future.delayed(const Duration(milliseconds: 200));
    setState((){
      duration = const Duration(milliseconds: 1500);
      logoLeft = size.width/2 - 100;
      opacity = 1;
    });
    await Future.delayed(duration);
    await Future.delayed(Duration(seconds: 2));

    var authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    try {
      await authProvider.retrieveToken();
    } on UnauthenticatedException {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (_, __, ___) => const LoginScreen(),
        ),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1500),
        pageBuilder: (_, __, ___) => MainScreen(sideBarIndex: 0,),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => animateItems(context));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            AnimatedPositioned(
              top: size.height / 2 - 100,
              left: logoLeft,
              curve : Curves.fastOutSlowIn,
              duration: duration,
              child: Container(
                width: 200,
                height: 200,
                child: Hero(
                  tag: "logo",
                  child: Image.asset(
                    "assets/foodit-website-favicon-color.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height / 2 + 90,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: duration,
                child: Container(
                  width: size.width,
                  alignment: Alignment.topCenter,
                  child: const Text(
                    "FOODIT!",
                    style: TextStyle(
                      fontFamily: "BungeeShade",
                      fontSize: 54,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
