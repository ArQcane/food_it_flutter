import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/review/review.dart';
import 'package:food_it_flutter/ui/screens/restaurant/specific_restaurant_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';

import '../../domain/restaurant/restaurant.dart';
import '../../domain/user/user.dart';
import '../../providers_viewmodels/restaurant_provider.dart';

class RestaurantCard extends StatelessWidget {
  final TransformedRestaurant transformedRestaurant;
  final List<Review> reviewsOfRestaurant;
  final User? currentUser;
  final void Function(
    bool toAddToFav,
    String restaurantId,
  ) toggleFavourite;

  RestaurantCard({
    Key? key,
    required this.transformedRestaurant,
    required this.reviewsOfRestaurant,
    required this.currentUser,
    required this.toggleFavourite,
  }) : super(key: key);

  double get averageRating {
    if (reviewsOfRestaurant.isEmpty) return 0;
    var totalRating = reviewsOfRestaurant.fold<double>(
        0, (previousValue, element) => previousValue + element.rating);
    return totalRating / reviewsOfRestaurant.length;
  }

  bool get isFavouritedByCurrentUser {
    return transformedRestaurant.usersWhoFavRestaurant
        .map((e) => e.userId)
        .contains(currentUser?.user_id);
  }

  List<Widget> priceCostWidgetList = [];

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    for (int x = 0;
    x < transformedRestaurant.restaurant.average_price_range.toInt();
    x++) {
      priceCostWidgetList.add(
        const Icon(
          Icons.attach_money,
          color: primary,
          size: 24,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: OpenContainer(
        closedBuilder: (context, openContainer) => _buildClosedContent(
          context,
          openContainer,
        ),
        openBuilder: (context, closeContainer) => SpecificRestaurantScreen(
          restaurantId: transformedRestaurant.restaurant.restaurant_id.toString(),
        ),
        closedElevation: 4,
        closedColor: isDarkMode
            ? ElevationOverlay.colorWithOverlay(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.onSurface,
          4,
        )
            : Colors.white,
        closedShape: const BeveledRectangleBorder(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fadeThrough,
        openColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget _buildClosedContent(
      BuildContext context,
      void Function() openContainer,
      ) {
    return InkWell(
      onTap: openContainer,
      splashFactory: InkRipple.splashFactory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: primary,
                width: 2,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                transformedRestaurant.restaurant.restaurant_logo,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        transformedRestaurant.restaurant.restaurant_name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        toggleFavourite(
                          !isFavouritedByCurrentUser,
                          transformedRestaurant.restaurant.restaurant_id.toString(),
                        );
                      },
                      icon: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [primaryAccent, primary],
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          );
                        },
                        child: Icon(
                          isFavouritedByCurrentUser
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                      splashRadius: 20,
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: primary),
                    const SizedBox(width: 2),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "/5 (${reviewsOfRestaurant.length})",
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 2),
                    Text(
                      "Price: ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ] +
                      priceCostWidgetList,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}





