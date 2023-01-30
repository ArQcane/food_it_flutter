import '../../../domain/restaurant/restaurant.dart';

abstract class RemoteRestaurantDao {
  Future<List<Restaurant>> getAllRestaurants();
  Future<Restaurant> getRestaurantById({required String restaurantId});
  Future<List<Restaurant>> getExpensiveRestaurant();
  Future<List<Restaurant>> searchRestaurant(String restaurantName);
  Future<List<Restaurant>> sortRestaurantsByDescendingRating();
  Future<List<Restaurant>> sortRestaurantsByAscendingRating();
}