import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';

import 'package:food_it_flutter/ui/components/reviews/edit_review_dialog.dart';

import 'package:food_it_flutter/ui/components/reviews/review_tab_grphs.dart';
import 'package:food_it_flutter/ui/screens/restaurant/all_reviews_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../data/exceptions/default_exception.dart';
import '../../../data/exceptions/field_exception.dart';
import '../../../domain/review/review.dart';
import '../../../providers_viewmodels/restaurant_provider.dart';
import '../../components/extras/action_button.dart';
import '../../components/extras/gradient_text.dart';
import '../../components/reviews/add_review_form.dart';
import '../../components/reviews/review_card.dart';

class SpecificRestaurantScreen extends StatefulWidget {
  final String restaurantId;

  const SpecificRestaurantScreen({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<SpecificRestaurantScreen> createState() =>
      _SpecificRestaurantScreenState();
}

class _SpecificRestaurantScreenState extends State<SpecificRestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    var restaurantProvider = Provider.of<RestaurantProvider>(context);
    var reviewProvider = Provider.of<ReviewProvider>(context);
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var transformedRestaurant = restaurantProvider.restaurantList.firstWhere(
      (element) =>
          element.restaurant.restaurant_id.toString() == widget.restaurantId,
    );
    var reviewsOfRestaurant = reviewProvider.reviewList
        .where((e) => e.review.idrestaurant.toString() == widget.restaurantId)
        .toList();
    var initialCameraPosition = const CameraPosition(
      target: LatLng(1.3610, 103.8200),
      zoom: 10.25,
    );
    List<Marker> _locationMarker = <Marker>[];
    _locationMarker.add(
      Marker(
        markerId:
            MarkerId(transformedRestaurant.restaurant.restaurant_id.toString()),
        position: LatLng(transformedRestaurant.restaurant.location_lat,
            transformedRestaurant.restaurant.location_long),
        infoWindow: InfoWindow(
          title: transformedRestaurant.restaurant.restaurant_name,
          snippet: transformedRestaurant.restaurant.location,
        ),
      ),
    );

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _parallaxToolbar(
                  restaurantProvider,
                  authProvider,
                  transformedRestaurant,
                )
              ];
            },
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      _buildRestaurantReviewMetaData(
                        reviewsOfRestaurant,
                        transformedRestaurant,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _userWhoFavouriteProgressbar(reviewsOfRestaurant,
                          transformedRestaurant, authProvider),
                      const SizedBox(height: 10),
                      const GradientText(
                        text: "Location of Restaurant",
                        textStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: primary,
                              width: 2,
                            ),
                          ),
                          child: GoogleMap(
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(() {
                                return EagerGestureRecognizer();
                              }),
                            },
                            initialCameraPosition: initialCameraPosition,
                            markers: Set<Marker>.of(_locationMarker),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const GradientText(
                            text: "Reviews",
                            textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (reviewsOfRestaurant.isNotEmpty)
                            ActionButton(
                                onClick: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AllReviewsScreen(
                                          restaurantId: widget.restaurantId,
                                        ),
                                      ),
                                    ),
                                text: "See all")
                        ],
                      ),
                      const SizedBox(height: 10),
                      AddReviewForm(restaurantId: widget.restaurantId),
                      const SizedBox(height: 10),
                      AnimatedCrossFade(
                        crossFadeState: reviewsOfRestaurant.isNotEmpty
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(
                          milliseconds: reviewsOfRestaurant.isEmpty ? 0 : 300,
                        ),
                        firstChild: Column(
                          children: [
                            ReviewTabGraphs(
                              reviewsOfRestaurant: reviewsOfRestaurant,
                            ),
                            const SizedBox(height: 10),
                            const Material(
                              elevation: 3,
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child:
                                    GradientText(text: "3 Most Recent Reviews"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    min(3, reviewsOfRestaurant.length),
                                    (index) {
                                  return Row(
                                    children: [
                                      ReviewCard(
                                        review: reviewsOfRestaurant[index],
                                        width: reviewsOfRestaurant.length == 1
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                32
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                56,
                                        editReview: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => EditReviewDialog(
                                              reviewObj:
                                                  reviewsOfRestaurant[index],
                                            ),
                                          );
                                        },
                                        deleteReview: () {
                                          reviewProvider.deleteReview(
                                            reviewsOfRestaurant[index]
                                                .review
                                                .review_id
                                                .toString(),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: reviewsOfRestaurant.length ==
                                                    1 ||
                                                index == 2 ||
                                                index ==
                                                    reviewsOfRestaurant.length -
                                                        1
                                            ? 0
                                            : 12,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        secondChild: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [primaryAccent, primary],
                                ).createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                                child: const Icon(Icons.insert_comment_outlined,
                                    size: 150),
                              ),
                              const Text(
                                "No reviews yet",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Add a review to be \nthe first review on this restaurant!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const GradientText(
                        text: "Biography",
                        textStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        transformedRestaurant.restaurant.biography,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ]),
              ),
            )));
  }

  Material _buildRestaurantReviewMetaData(
      List<TransformedReview> reviewsOfRestaurant,
      TransformedRestaurant transformedRestaurant) {
    return Material(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Icon(
                  Icons.star,
                  color: primary,
                  size: 24,
                ),
                GradientText(
                  text: _getAvgRating(reviewsOfRestaurant).toStringAsFixed(1),
                ),
                const Text("AVG Rating"),
              ],
            ),
            Column(
              children: [
                const Icon(
                  Icons.reviews_rounded,
                  color: primary,
                  size: 24,
                ),
                GradientText(
                  text: reviewsOfRestaurant.length.toString(),
                ),
                const Text("Reviews"),
              ],
            ),
            Column(
              children: [
                const Icon(
                  Icons.attach_money,
                  color: primary,
                  size: 24,
                ),
                GradientText(
                  text: transformedRestaurant.restaurant.average_price_range
                      .toStringAsFixed(1)
                      .toString(),
                ),
                const Text("Pricy-ness"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Material _userWhoFavouriteProgressbar(
      List<TransformedReview> reviewsOfRestaurant,
      TransformedRestaurant transformedRestaurant,
      AuthenticationProvider authProvider) {
    return Material(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          children: [
            Column(
              children: [
                GradientText(
                  text: transformedRestaurant.usersWhoFavRestaurant.length
                      .toString(),
                ),
                const Text("User Favourited"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 215,
                animation: true,
                animateFromLastPercent: true,
                lineHeight: 12.0,
                animationDuration: 1000,
                trailing: const Icon(
                  Icons.person_pin_circle,
                  color: primary,
                  size: 30,
                ),
                percent: transformedRestaurant.usersWhoFavRestaurant.length /
                    authProvider.allUsersInDB.length,
                barRadius: const Radius.circular(16),
                progressColor: primary,
              ),
            )
          ],
        ),
      ),
    );
  }

  double _getAvgRating(List<TransformedReview> reviewList) {
    if (reviewList.isEmpty) return 0;
    var totalRating = reviewList.fold<double>(
      0,
      (previousValue, element) => previousValue + element.review.rating,
    );
    return totalRating / reviewList.length.toDouble();
  }

  SliverLayoutBuilder _parallaxToolbar(
    RestaurantProvider restaurantProvider,
    AuthenticationProvider authProvider,
    TransformedRestaurant transformedRestaurant,
  ) {
    var width = MediaQuery.of(context).size.width;
    var currentUser = authProvider.user;
    var isFavoriteByCurrentUser = transformedRestaurant.usersWhoFavRestaurant
        .map((e) => e.userId)
        .contains(currentUser?.user_id);

    return SliverLayoutBuilder(builder: (context, offset) {
      var percent = offset.scrollOffset / (width - 52);
      if (offset.scrollOffset >= width - 52) percent = 1;
      var color = percent == 0
          ? primary
          : percent <= 0.7 && percent >= 0
              ? primaryAccent
              : Colors.black
                  .withBlue((percent * Colors.white.blue).toInt())
                  .withGreen((percent * Colors.white.green).toInt())
                  .withRed((percent * Colors.white.red).toInt());
      var materialColor = percent == 0
          ? Colors.white
          : percent <= 0.7 && percent >= 0
              ? Colors.white
              : primary;

      var startPadding = 16 + (72 - 16) * percent;

      return SliverAppBar(
        expandedHeight: width,
        surfaceTintColor: Colors.white,
        floating: false,
        pinned: true,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: materialColor.withOpacity(1 - percent),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 20,
              icon: Icon(Icons.arrow_back, color: color),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: materialColor.withOpacity(1 - percent),
              ),
              child: IconButton(
                onPressed: () {
                  restaurantProvider.toggleRestaurantFavourite(
                    widget.restaurantId,
                    currentUser!,
                    !isFavoriteByCurrentUser,
                  );
                },
                splashRadius: 20,
                icon: Icon(
                  isFavoriteByCurrentUser
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: color,
                ),
              ),
            ),
          )
        ],
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsetsDirectional.only(
            start: startPadding,
            bottom: 16,
          ),
          title: percent >= 0 && percent <= 0.7
              ? Material(
                  elevation: 4,
                  color: materialColor.withOpacity(1 - percent),
                  animationDuration: const Duration(milliseconds: 1000),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      transformedRestaurant.restaurant.restaurant_name,
                      style: TextStyle(
                        color: color,
                      ),
                    ),
                  ),
                )
              : Text(
                  transformedRestaurant.restaurant.restaurant_name,
                  style: TextStyle(
                    color: color,
                  ),
                ),
          background: Image.network(
            transformedRestaurant.restaurant.restaurant_logo,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}
