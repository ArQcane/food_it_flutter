import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/extras/gradient_text.dart';
import 'package:provider/provider.dart';

import '../../../domain/user/user.dart';
import '../../../providers_viewmodels/restaurant_provider.dart';
import '../../../providers_viewmodels/review_provider.dart';
import '../../components/extras/rive_animations/rive_favourites_animation.dart';
import '../../components/restaurants/restaurant_card.dart';
import '../../theme/colors.dart';

class FavouriteScreen extends StatefulWidget {
  final User user;

  const FavouriteScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var currentUser = authProvider.user;
    var restaurantsProvider = Provider.of<RestaurantProvider>(context);
    var reviewsProvider = Provider.of<ReviewProvider>(context);
    var favoriteRestaurantsOfUser = restaurantsProvider.restaurantList
        .where(
          (restaurant) => restaurant.usersWhoFavRestaurant
              .map((e) => e.userId)
              .contains(widget.user.user_id),
        )
        .toList();
    var chunkedFavoriteRestaurants = <List<TransformedRestaurant>>[];
    for (var i = 0; i < favoriteRestaurantsOfUser.length; i += 2) {
      chunkedFavoriteRestaurants.add(
        favoriteRestaurantsOfUser.skip(i).take(2).toList(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favourites",
        ),
      ),
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            const GradientText(text: "Favourite Restaurants"),
            _buildFavRestaurantSection(
              reviewsProvider,
              restaurantsProvider,
              authProvider,
              chunkedFavoriteRestaurants,
              currentUser,
            ),
            SizedBox(height: 70,)
          ],
        ),
      ),
    );
  }
}

Widget _buildFavRestaurantSection(
  ReviewProvider reviewsProvider,
  RestaurantProvider restaurantsProvider,
  AuthenticationProvider authProvider,
  List<List<TransformedRestaurant>> chunkedFavoriteRestaurants,
  User? currentUser,
) {
  if (chunkedFavoriteRestaurants.isEmpty) return EmptyFavouritesWidget();

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          ...chunkedFavoriteRestaurants.map(
            (restaurantRow) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 280,
                        child: RestaurantCard(

                          transformedRestaurant: restaurantRow[0],
                          reviewsOfRestaurant: reviewsProvider.reviewList
                              .where(
                                (element) =>
                                    element.review.idrestaurant ==
                                    restaurantRow[0].restaurant.restaurant_id,
                              )
                              .toList(),
                          currentUser: currentUser,
                          toggleFavourite: (shouldFavorite, restaurantId) {
                            restaurantsProvider.toggleRestaurantFavourite(
                              restaurantId,
                              currentUser!,
                              shouldFavorite,
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: restaurantRow.length == 1
                          ? Container()
                          : RestaurantCard(
                              transformedRestaurant: restaurantRow[1],
                              reviewsOfRestaurant: reviewsProvider.reviewList
                                  .where(
                                    (element) =>
                                        element.review.idrestaurant ==
                                        restaurantRow[1]
                                            .restaurant
                                            .restaurant_id,
                                  )
                                  .toList(),
                              currentUser: currentUser,
                              toggleFavourite: (shouldFavorite, restaurantId) {
                                restaurantsProvider.toggleRestaurantFavourite(
                                  restaurantId,
                                  currentUser!,
                                  shouldFavorite,
                                );
                              },
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class EmptyFavouritesWidget extends StatelessWidget {
  const EmptyFavouritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: background,
      child: Column(
        children: [
          RiveEmptyFavouritesAnimation(),
          Material(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 150,
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
              ),
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
          ),
        ],
      ),
    );
  }
}
