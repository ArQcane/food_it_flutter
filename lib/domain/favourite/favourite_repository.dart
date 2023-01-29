import '../restaurant/restaurant.dart';
import '../user/user.dart';

abstract class FavouriteRepository {
  Future<List<Restaurant>> getFavoriteRestaurantsOfUser({required String userId});
  Future<List<Restaurant>> getUsersWhoFavouriteRestaurant({required String restaurantId});
  Future<String> addFavorite({
    required String userId,
    required String restaurantId,
  });
  Future<String> removeFavorite({
    required String userId,
    required String restaurantId,
  });
}