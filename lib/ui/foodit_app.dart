import 'package:flutter/material.dart';
import 'package:food_it_flutter/ui/splash_screen.dart';
import 'package:provider/provider.dart';

import '../providers_viewmodels/restaurant_provider.dart';

class FoodItApp extends StatelessWidget {
  const FoodItApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodIt!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFFFF5E4)
      ),
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var restaurantProvider = Provider.of<RestaurantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello world"),
        actions: [
          IconButton(
            onPressed: () => restaurantProvider.getRestaurants(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: restaurantProvider.isLoading
          ? Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      )
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    restaurantProvider.restaurantList[index].restaurant_logo!,
                  ),
                ),
                Text(restaurantProvider.restaurantList[index].restaurant_name),
              ],
            ),
          );
        },
        itemCount: restaurantProvider.restaurantList.length,
      ),
    );
  }
}