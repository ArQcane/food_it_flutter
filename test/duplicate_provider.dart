import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/restaurant_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/user_provider.dart';
import 'package:food_it_flutter/ui/theme/theme.dart';
import 'package:provider/provider.dart';

import 'duplicate/dup_favourite_repo.dart';
import 'duplicate/dup_restaurant_repo.dart';
import 'duplicate/dup_review_repo.dart';
import 'duplicate/dup_user_repo.dart';

class DuplicateProvider extends StatelessWidget {
  late final DuplicateRestaurantRepo restaurantRepo;
  late final DuplicateUserRepo userRepo;
  late final DuplicateReviewRepo reviewRepo;
  late final DuplicateFavouriteRepo favoriteRepo;
  late final UserProvider userProvider;
  late final AuthenticationProvider authProvider;
  late final RestaurantProvider restaurantProvider;
  late final ReviewProvider reviewProvider;
  final Widget child;

  DuplicateProvider({
    Key? key,
    required this.child,
  }) : super(key: key) {
    restaurantRepo = DuplicateRestaurantRepo();
    userRepo = DuplicateUserRepo();
    reviewRepo = DuplicateReviewRepo();
    favoriteRepo = DuplicateFavouriteRepo(userRepo, restaurantRepo);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = UserProvider(userRepo);
    authProvider = AuthenticationProvider(
      userRepo,
      userProvider,
    );
    restaurantProvider = RestaurantProvider(
      context,
      restaurantRepo,
      favoriteRepo,
    );
    reviewProvider = ReviewProvider(
      context,
      reviewRepo,
      userRepo
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => authProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => userProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => restaurantProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => reviewProvider,
        ),
      ],
      child: MaterialApp(
        title: 'FoodIt!',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: child,
      ),
    );
  }
}