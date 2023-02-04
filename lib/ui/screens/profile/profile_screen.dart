
import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/components/extras/gradient_text.dart';
import 'package:food_it_flutter/ui/components/reviews/review_card.dart';
import 'package:food_it_flutter/ui/screens/profile/update/profile_image_picker.dart';
import 'package:food_it_flutter/ui/screens/profile/reset_password/reset_password_screen.dart';
import 'package:food_it_flutter/ui/screens/profile/update/update_profile_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';
import '../../../domain/user/user.dart';
import '../../../providers_viewmodels/restaurant_provider.dart';
import 'delete/delete_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bool _isUpdatingImage = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
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
    var currentUser = authProvider.user;
    var reviewsOfUser = reviewsProvider.reviewList
        .where((review) => review.reviewUser.user_id == widget.user.user_id)
        .toList();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            _buildAppBar(context, currentUser, authProvider),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserStats(
                reviewsOfUser,
                favoriteRestaurantsOfUser,
              ),
              const SizedBox(
                height: 20,
              ),
              _profileButtons(context, currentUser, authProvider),
              const SizedBox(
                height: 20,
              ),
              _buildReviewsSection(reviewsOfUser),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsSection(List<TransformedReview> reviewsOfUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GradientText(text: "Reviews"),
        const SizedBox(height: 5),
        ...reviewsOfUser.map(
          (review) => Column(
            children: [
              ReviewCard(
                review: review,
                width: double.infinity,
                editReview: () {},
                deleteReview: () {},
                reviewMode: ReviewMode.restaurant,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        if (reviewsOfUser.isEmpty)
          Material(
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: const Text(
                "No reviews yet",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
      ],
    );
  }

  Material _buildUserStats(
    List<TransformedReview> reviewsOfUser,
    List<TransformedRestaurant> favoriteRestaurantsOfUser,
  ) {
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
                GradientText(
                  text: _getAvgRating(reviewsOfUser).toStringAsFixed(1),
                ),
                const Text("AVG Rating"),
              ],
            ),
            Column(
              children: [
                GradientText(
                  text: reviewsOfUser.length.toString(),
                ),
                const Text("Reviews"),
              ],
            ),
            Column(
              children: [
                GradientText(
                  text: favoriteRestaurantsOfUser.length.toString(),
                ),
                const Text("Favorites"),
              ],
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

  Widget _profileButtons(
    BuildContext context,
    User? currentUser,
    AuthenticationProvider authenticationProvider,
  ) {
    return Row(
      children: [
        Flexible(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (currentUser != null && currentUser.user_id == widget.user.user_id)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UpdateProfileScreen(),
                      ),
                    );
                },
                child: Material(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: primary,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(text: "Edit Profile"),
                            Text(
                              "Navigate to the edit profile screen from here",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primary,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (currentUser != null && currentUser.user_id == widget.user.user_id)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DeleteAccountScreen(),
                      ),
                    );
                },
                child: Material(
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: primary,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(text: "Delete Profile"),
                            Padding(
                              padding: EdgeInsets.only(right: 120),
                              child: Text(
                                "Delete profile forever",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primary,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  );
                },
                child: Material(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.change_circle_rounded,
                              color: primary,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(text: "Change Password"),
                            Padding(
                              padding: EdgeInsets.only(right: 40),
                              child: Text(
                                "A email verification link will be sent!",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    User? currentUser,
    AuthenticationProvider authenticationProvider,
  ) {
    return SliverAppBar(
      backgroundColor: secondaryAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.user.username,
          style: const TextStyle(
            color: primary,
            fontSize: 18.0,
          ),
        ),
        background: Center(
          child: ProfileImagePicker(user: widget.user),
        ),
      ),
    );
  }
}