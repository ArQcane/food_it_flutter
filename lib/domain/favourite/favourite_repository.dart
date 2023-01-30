import '../restaurant/restaurant.dart';
import '../user/user.dart';

abstract class FavouriteRepository {
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