import 'package:flutter/material.dart';
import 'package:food_it_flutter/ui/screens/auth/splash_screen.dart';
import 'package:food_it_flutter/ui/theme/theme.dart';
import 'package:provider/provider.dart';

import '../providers_viewmodels/restaurant_provider.dart';

class FoodItApp extends StatelessWidget {
  const FoodItApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodIt!',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}