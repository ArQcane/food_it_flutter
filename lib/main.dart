import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_it_flutter/data/favourites/favourite_repository_impl.dart';
import 'package:food_it_flutter/data/favourites/remote/remote_favourite_dao_impl.dart';
import 'package:food_it_flutter/data/review/remote/remote_review_dao_impl.dart';
import 'package:food_it_flutter/data/review/review_repository_impl.dart';
import 'package:food_it_flutter/data/user/local/local_user_dao_impl.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/restaurant_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/foodit_app.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/restaurant/remote/remote_restaurant_dao_impl.dart';
import 'data/restaurant/restaurant_repository_impl.dart';
import 'data/user/remote/remote_user_dao_impl.dart';
import 'data/user/user_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryAccent,
    ),
  );

  var sharedPreferences = await SharedPreferences.getInstance();

  var favouriteRepo = FavouriteRepositoryImpl(
    remoteFavouriteDao: RemoteFavouriteDaoImpl(),
  );

  var userRepo = UserRepositoryImpl(
    remoteUserDao: RemoteUserDaoImpl(),
    localUserDao: LocalUserDaoImpl(
      preferences: sharedPreferences,
    ),
  );

  var restaurantRepo = RestaurantRepositoryImpl(
    restaurantDao: RemoteRestaurantDaoImpl(),
  );
  var reviewRepo = ReviewRepositoryImpl(
    remoteCommentDao: RemoteReviewDaoImpl(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(context, userRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantProvider(context, restaurantRepo, favouriteRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(context, reviewRepo),
        ),
      ],
      child: const FoodItApp(),
    ),
  );
}
