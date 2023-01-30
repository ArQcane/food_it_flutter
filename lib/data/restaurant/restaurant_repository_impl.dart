import 'package:food_it_flutter/data/restaurant/remote/remote_restaurant_dao.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository{
  final RemoteRestaurantDao _dao;
  RestaurantRepositoryImpl({required RemoteRestaurantDao restaurantDao}): _dao = restaurantDao;

  @override
  Future<List<Restaurant>> getAllRestaurants() {
    return _dao.getAllRestaurants();
  }

  @override
  Future<List<Restaurant>> getExpensiveRestaurant() {
    return _dao.getExpensiveRestaurant();
  }

  @override
  Future<Restaurant> getRestaurantById({required String restaurantId}) {
    return _dao.getRestaurantById(restaurantId: restaurantId);
  }

  @override
  Future<List<Restaurant>> searchRestaurant(String restaurantName) {
    return _dao.searchRestaurant(restaurantName);
  }

  @override
  Future<List<Restaurant>> sortRestaurantsByAscendingRating() {
    return _dao.sortRestaurantsByAscendingRating();
  }

  @override
  Future<List<Restaurant>> sortRestaurantsByDescendingRating() {
    return _dao.sortRestaurantsByDescendingRating();
  }
  
  
}