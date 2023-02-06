import 'package:food_it_flutter/domain/restaurant/restaurant.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant_repository.dart';

class DuplicateRestaurantRepo implements RestaurantRepository {
  List<Restaurant> restaurants = [];

  DuplicateRestaurantRepo() {
    restaurants = List.generate(
      10,
          (index) => Restaurant(
        restaurant_id: index,
        restaurant_name: "name $index",
        biography: "description $index",
        average_price_range: index.toDouble(),
        average_rating: index.toDouble(),
        cuisine: "cusine",
        location: "location: $index",
        location_lat: index.toDouble(),
        location_long: index.toDouble(),
        opening_hours: "opening hours:",
        region: "north",
        restaurant_banner: "http://10.0.2.2:8080/images/restaurant_banner/kotuwa.png",
        restaurant_logo: "http://10.0.2.2:8080/images/restaurant_logo/kotuwa.jpg",
      ),
    );
  }



  @override
  Future<List<Restaurant>> getAllRestaurants() async {
    return restaurants;
  }

  @override
  Future<Restaurant> getRestaurantById({
    required String restaurantId,
  }) async {
    return restaurants.firstWhere((element) => element.restaurant_id.toString() == restaurantId);
  }

  @override
  Future<List<Restaurant>> getExpensiveRestaurant() {
    // TODO: implement getExpensiveRestaurant
    throw UnimplementedError();
  }

  @override
  Future<List<Restaurant>> searchRestaurant(String restaurantName) {
    // TODO: implement searchRestaurant
    throw UnimplementedError();
  }

  @override
  Future<List<Restaurant>> sortRestaurantsByAscendingRating() {
    // TODO: implement sortRestaurantsByAscendingRating
    throw UnimplementedError();
  }

  @override
  Future<List<Restaurant>> sortRestaurantsByDescendingRating() {
    // TODO: implement sortRestaurantsByDescendingRating
    throw UnimplementedError();
  }

}