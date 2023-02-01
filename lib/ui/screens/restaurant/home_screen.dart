import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/components/gradient_text.dart';
import 'package:food_it_flutter/ui/screens/auth/login_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';
import '../../../providers_viewmodels/restaurant_provider.dart';
import '../../components/restaurant_card.dart';

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
        title: Text(
          currentUser == null ? "Loading..." : "Home",
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
                      child: GradientText(text: "Your Favorite Restaurants"),
                    ),
                    FavouriteRestaurantSection(
                      restaurantProvider: restaurantProvider,
                      authProvider: authProvider,
                      reviewProvider: reviewProvider,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
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

class FavouriteRestaurantSection extends StatelessWidget {
  const FavouriteRestaurantSection({
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

    var favouriteRestaurants = restaurantProvider.restaurantList
        .where(
          (element) => element.usersWhoFavRestaurant
              .map((e) => e.userId)
              .contains(currentUser?.user_id),
        )
        .toList()
      ..sort((a, b) => a.restaurant.restaurant_name.compareTo(b.restaurant.restaurant_name));

    if (favouriteRestaurants.isEmpty) return const EmptyFavoritesContent();

    return SizedBox(
      width: double.infinity,
      height: 310,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: RestaurantCard(
              toggleFavourite: (toggleFav, restaurantId) {
                if (toggleFav) {
                  restaurantProvider.toggleRestaurantFavourite(
                      restaurantId,
                      currentUser!,
                      toggleFav
                  );
                  return;
                }
                restaurantProvider.removeRestaurantFromFavorite(
                  restaurantId,
                  currentUser!,
                );
              },
              reviewsOfRestaurant: reviewProvider.reviewList
                  .where(
                    (element) =>
                        element.idrestaurant ==
                        favouriteRestaurants[index].restaurant.restaurant_id,
                  )
                  .toList(),
              currentUser: currentUser,
              transformedRestaurant: favouriteRestaurants[index],
            ),
          );
        },
        itemCount: min(favouriteRestaurants.length, 5),
      ),
    );
  }
}

class EmptyFavoritesContent extends StatelessWidget {
  const EmptyFavoritesContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [primaryAccent, primary],
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              );
            },
            child: const Icon(
              Icons.heart_broken,
              size: 200,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              "Seems like you don't have any favourites yet!\nTry favoriting a restaurant now!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ],
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
          return element.idrestaurant == a.restaurant.restaurant_id;
        });
        var reviewsOfB = reviewProvider.reviewList.where((element) {
          return element.idrestaurant == b.restaurant.restaurant_id;
        });

        var totalRatingOfA = reviewsOfA.fold<double>(0, (value, element) {
          return value + element.rating;
        });
        var totalRatingOfB = reviewsOfB.fold<double>(0, (value, element) {
          return value + element.rating;
        });

        var averageRatingOfA =
            reviewsOfA.isEmpty ? 0 : totalRatingOfA / reviewsOfA.length;
        var averageRatingOfB =
            reviewsOfB.isEmpty ? 0 : totalRatingOfB / reviewsOfB.length;
        return averageRatingOfB.compareTo(averageRatingOfA);
      });
    return SizedBox(
      width: double.infinity,
      height: 310,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: RestaurantCard(
              toggleFavourite: (toggleFav, restaurantId) {
                if (toggleFav) {
                  restaurantProvider.toggleRestaurantFavourite(
                    restaurantId,
                    currentUser!,
                    toggleFav
                  );
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
                  return element.idrestaurant ==
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
        return Row(
          children: [
            Expanded(
              child: RestaurantCard(
                toggleFavourite: (toggleFav, restaurantId) {
                  if (toggleFav) {
                    restaurantProvider.toggleRestaurantFavourite(
                        restaurantId,
                        currentUser!,
                        toggleFav
                    );
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
                    return element.idrestaurant ==
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
                              restaurantId,
                              currentUser!,
                              toggleFav
                          );
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
                          return element.idrestaurant ==
                              restaurantList[index][1].restaurant.restaurant_id;
                        },
                      ).toList(),
                      transformedRestaurant: restaurantList[index][1],
                    ),
            ),
          ],
        );
      },
      itemCount: restaurantList.length,
    );
  }
}
