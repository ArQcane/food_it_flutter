import 'package:food_it_flutter/domain/favourite/favourite_repository.dart';

import '../../../domain/restaurant/restaurant.dart';
import '../../../domain/user/user.dart';

abstract class RemoteFavouriteDao{
  Future<List<Restaurant>> getFavouriteRestaurantsOfUser({required String userId});
  Future<List<User>> getUsersWhoFavouriteRestaurant({required String restaurantId});
  Future<String> addFavourite({
    required String userId,
    required String restaurantId,
  });
  Future<void> removeFavourite({
    required String userId,
    required String restaurantId,
  });
}