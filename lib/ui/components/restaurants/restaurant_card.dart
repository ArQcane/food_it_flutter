import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:food_it_flutter/ui/utils/AppDefaults.dart';

import '../../../domain/user/user.dart';
import '../../../providers_viewmodels/restaurant_provider.dart';
import '../../../providers_viewmodels/review_provider.dart';
import '../../screens/restaurant/specific_restaurant_screen.dart';

class RestaurantCard extends StatelessWidget {
  final TransformedRestaurant transformedRestaurant;
  final List<TransformedReview> reviewsOfRestaurant;
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
        0, (previousValue, element) => previousValue + element.review.rating);
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
        Icon(
          Icons.attach_money,
          color: primary,
          size: 20,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: AppDefaults.padding / 2),
      child: OpenContainer(
        closedBuilder: (context, openContainer) => _buildClosedContent(
          context,
          openContainer,
        ),
        openBuilder: (context, closeContainer) => SpecificRestaurantScreen(
          restaurantId:
              transformedRestaurant.restaurant.restaurant_id.toString(),
        ),
        closedElevation: 4,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        closedColor: Colors.white,
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
      child: Material(
        borderRadius: AppDefaults.borderRadius,
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(width: 0.1, color: primary),
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          transformedRestaurant.restaurant.restaurant_logo,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: FractionalOffset.center,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              primaryAccent.withOpacity(0.3),
                            ],
                            stops: [
                              0.0,
                              1.0
                            ])),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        transformedRestaurant.restaurant.restaurant_name,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: primary),
                      ),
                      Text(
                        transformedRestaurant.restaurant.cuisine,
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Container(
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: primary),
                        const SizedBox(width: 4),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          " (${reviewsOfRestaurant.length})",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          padding: EdgeInsets.all(2),
                          constraints: BoxConstraints(),
                          onPressed: () {
                            toggleFavourite(
                              !isFavouritedByCurrentUser,
                              transformedRestaurant.restaurant.restaurant_id
                                  .toString(),
                            );
                          },
                          icon: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [primaryAccent, primary],
                              ).createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              );
                            },
                            child: Icon(
                              isFavouritedByCurrentUser
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                          ),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        child: Row(
                          children: [
                            Row(
                              children: List.generate(
                                  transformedRestaurant
                                      .restaurant.average_price_range
                                      .toInt(),
                                  (index) => Icon(
                                        Icons.attach_money,
                                        color: primary,
                                        size: 20,
                                      )),
                            ),
                            Row(
                              children: List.generate(
                                  5 -
                                      transformedRestaurant
                                          .restaurant.average_price_range
                                          .toInt(),
                                  (index) => Icon(
                                        Icons.attach_money,
                                        color: Colors.grey,
                                        size: 20,
                                      )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
