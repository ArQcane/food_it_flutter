import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/components/gradient_text.dart';
import 'package:food_it_flutter/ui/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/restaurant/restaurant.dart';
import '../../providers_viewmodels/restaurant_provider.dart';
import '../components/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var restaurantProvider = Provider.of<RestaurantProvider>(context);
    var reviewProvider = Provider.of<ReviewProvider>(context);

    List<List<Restaurant>> restaurantList = [];

    for (var i = 0; i < restaurantProvider.restaurantList.length; i += 2) {
      var items = [restaurantProvider.restaurantList[i]];
      if (i + 1 == restaurantProvider.restaurantList.length) {
        restaurantList.add(items);
        break;
      }
      items.add(restaurantProvider.restaurantList[i + 1]);
      restaurantList.add(items);
    }

    var featuredRestaurants = restaurantProvider.restaurantList
      ..sort((a, b) {
        var reviewsOfA = reviewProvider.reviewList.where((element) {
          return element.idrestaurant == a.restaurant_id;
        });
        var reviewsOfB = reviewProvider.reviewList.where((element) {
          return element.idrestaurant == b.restaurant_id;
        });

        var totalRatingOfA = reviewsOfA.fold<double>(0, (value, element) {
          return value + element.rating;
        });
        var totalRatingOfB = reviewsOfB.fold<double>(0, (value, element) {
          return value + element.rating;
        });

        var averageRatingOfA = totalRatingOfA / max(1, reviewsOfA.length);
        var averageRatingOfB = totalRatingOfB / max(1, reviewsOfB.length);
        return averageRatingOfB.compareTo(averageRatingOfA);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              var provider = Provider.of<AuthenticationProvider>(context, listen: false);
              await provider.logOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(animate: false),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: restaurantProvider.isLoading
          ? Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: () => restaurantProvider.getRestaurants(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(5),
                child: GradientText(text: "Featured Restaurants"),
              ),
              SizedBox(
                width: double.infinity,
                height: 215,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: RestaurantCard(
                        restaurant: featuredRestaurants[index],
                      ),
                    );
                  },
                  itemCount: 5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: GradientText(text: "All Restaurants"),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: RestaurantCard(
                          restaurant: restaurantList[index][0],
                        ),
                      ),
                      Expanded(
                        child: restaurantList[index].length == 1
                            ? Container()
                            : RestaurantCard(
                          restaurant: restaurantList[index][1],
                        ),
                      ),
                    ],
                  );
                },
                itemCount: restaurantList.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}