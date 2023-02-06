import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/components/extras/rive_animations/rive_favourites_animation.dart';
import 'package:food_it_flutter/ui/screens/auth/login_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../../../providers_viewmodels/restaurant_provider.dart';
import '../../components/extras/gradient_text.dart';
import '../../components/extras/rive_animations/rive_isLoading_card.dart';
import '../../components/restaurants/restaurant_card.dart';
import '../../components/restaurants/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var restaurantProvider = Provider.of<RestaurantProvider>(context);
    var reviewProvider = Provider.of<ReviewProvider>(context);

    var currentUser = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 48),
          child: Text(
            currentUser == null ? "Loading..." : "Home",
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var provider =
                  Provider.of<AuthenticationProvider>(context, listen: false);
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
          ? RiveIsLoadingContainer(

            )
          : RefreshIndicator(
              onRefresh: () async {
                restaurantProvider.getRestaurants();
                reviewProvider.getReviews();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Material(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  GradientText(text: "Welcome Back!", textStyle: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
                                  GradientText(text: authProvider.user !=  null ?authProvider.user!.username: "Loading...", textStyle: TextStyle(fontSize: 32),),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 320,
                            width: MediaQuery.of(context).size.width,
                            child: RiveAnimation.asset("assets/rive/home-screen-summertime-ice-cream.riv", fit: BoxFit.scaleDown,),
                          )
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: GradientText(text: "Featured Restaurants"),
                    ),
                    FeaturedRestaurantSection(
                        restaurantProvider: restaurantProvider,
                        authProvider: authProvider,
                        reviewProvider: reviewProvider),
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: GradientText(text: "All Restaurants"),
                    ),
                    AllRestaurantsSection(
                      restaurantProvider: restaurantProvider,
                      authProvider: authProvider,
                      reviewProvider: reviewProvider,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class FeaturedRestaurantSection extends StatelessWidget {
  const FeaturedRestaurantSection({
    Key? key,
    required this.restaurantProvider,
    required this.authProvider,
    required this.reviewProvider,
  }) : super(key: key);

  final RestaurantProvider restaurantProvider;
  final AuthenticationProvider authProvider;
  final ReviewProvider reviewProvider;

  @override
  Widget build(BuildContext context) {
    var currentUser = authProvider.user;

    var featuredRestaurants = restaurantProvider.restaurantList
      ..sort((a, b) {
        var reviewsOfA = reviewProvider.reviewList.where((element) {
          return element.review.idrestaurant == a.restaurant.restaurant_id;
        });
        var reviewsOfB = reviewProvider.reviewList.where((element) {
          return element.review.idrestaurant == b.restaurant.restaurant_id;
        });

        var totalRatingOfA = reviewsOfA.fold<double>(0, (value, element) {
          return value + element.review.rating;
        });
        var totalRatingOfB = reviewsOfB.fold<double>(0, (value, element) {
          return value + element.review.rating;
        });

        var averageRatingOfA =
            reviewsOfA.isEmpty ? 0 : totalRatingOfA / reviewsOfA.length;
        var averageRatingOfB =
            reviewsOfB.isEmpty ? 0 : totalRatingOfB / reviewsOfB.length;
        return averageRatingOfB.compareTo(averageRatingOfA);
      });
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 2 + 20,
            child: RestaurantCard(
              toggleFavourite: (toggleFav, restaurantId) {
                if (toggleFav) {
                  restaurantProvider.toggleRestaurantFavourite(
                      restaurantId, currentUser!, toggleFav);
                  return;
                }
                restaurantProvider.removeRestaurantFromFavorite(
                  restaurantId,
                  currentUser!,
                );
              },
              currentUser: currentUser,
              reviewsOfRestaurant: reviewProvider.reviewList.where(
                (element) {
                  return element.review.idrestaurant ==
                      featuredRestaurants[index].restaurant.restaurant_id;
                },
              ).toList(),
              transformedRestaurant: featuredRestaurants[index],
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }
}

class AllRestaurantsSection extends StatelessWidget {
  final RestaurantProvider restaurantProvider;
  final AuthenticationProvider authProvider;
  final ReviewProvider reviewProvider;

  const AllRestaurantsSection({
    Key? key,
    required this.restaurantProvider,
    required this.authProvider,
    required this.reviewProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = authProvider.user;
    List<List<TransformedRestaurant>> restaurantList = [];
    for (var i = 0; i < restaurantProvider.restaurantList.length; i += 2) {
      var items = [restaurantProvider.restaurantList[i]];
      if (i + 1 == restaurantProvider.restaurantList.length) {
        restaurantList.add(items);
        break;
      }
      items.add(restaurantProvider.restaurantList[i + 1]);
      restaurantList.add(items);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          height: 280,
          child: Row(
            children: [
              Expanded(
                child: RestaurantCard(
                  toggleFavourite: (toggleFav, restaurantId) {
                    if (toggleFav) {
                      restaurantProvider.toggleRestaurantFavourite(
                          restaurantId, currentUser!, toggleFav);
                      return;
                    }
                    restaurantProvider.removeRestaurantFromFavorite(
                      restaurantId,
                      currentUser!,
                    );
                  },
                  currentUser: currentUser,
                  reviewsOfRestaurant: reviewProvider.reviewList.where(
                    (element) {
                      return element.review.idrestaurant ==
                          restaurantList[index][0].restaurant.restaurant_id;
                    },
                  ).toList(),
                  transformedRestaurant: restaurantList[index][0],
                ),
              ),
              Expanded(
                child: restaurantList[index].length == 1
                    ? Container()
                    : RestaurantCard(
                        toggleFavourite: (toggleFav, restaurantId) {
                          if (toggleFav) {
                            restaurantProvider.toggleRestaurantFavourite(
                                restaurantId, currentUser!, toggleFav);
                            return;
                          }
                          restaurantProvider.removeRestaurantFromFavorite(
                            restaurantId,
                            currentUser!,
                          );
                        },
                        currentUser: currentUser,
                        reviewsOfRestaurant: reviewProvider.reviewList.where(
                          (element) {
                            return element.review.idrestaurant ==
                                restaurantList[index][1].restaurant.restaurant_id;
                          },
                        ).toList(),
                        transformedRestaurant: restaurantList[index][1],
                      ),
              ),
            ],
          ),
        );
      },
      itemCount: restaurantList.length,
    );
  }
}
