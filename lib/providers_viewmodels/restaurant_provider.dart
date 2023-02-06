import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant_repository.dart';

import '../data/exceptions/default_exception.dart';
import '../domain/favourite/favourite.dart';
import '../domain/favourite/favourite_repository.dart';
import '../domain/restaurant/restaurant.dart';
import '../domain/user/user.dart';


class TransformedRestaurant {
  Restaurant restaurant;
  List<Favourite> usersWhoFavRestaurant;

  TransformedRestaurant({
    required this.restaurant,
    required this.usersWhoFavRestaurant,
  });
}

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository _restaurantRepo;
  final FavouriteRepository _favouriteRepo;
  final BuildContext _context;
  bool isLoading = false;
  List<TransformedRestaurant> restaurantList = [];

  RestaurantProvider(
      this._context,
      this._restaurantRepo,
      this._favouriteRepo,
      ) {
    getRestaurants();
  }

  Future<void> getRestaurants() async {
    isLoading = true;
    notifyListeners();
    try {
      var restaurants = await _restaurantRepo.getAllRestaurants()
        ..sort((a, b) {
          return a.restaurant_name.toLowerCase().compareTo(b.restaurant_name.toLowerCase());
        });
      var transformedRestaurants = restaurants.map((e) async {
        var favorites = await _favouriteRepo.getUsersWhoFavouriteRestaurant(
          restaurantId: e.restaurant_id.toString(),
        );
        return TransformedRestaurant(
          restaurant: e,
          usersWhoFavRestaurant: favorites,
        );
      }).toList();
      restaurantList = await Future.wait(transformedRestaurants);
      await Future.delayed(Duration(seconds: 2));
      isLoading = false;
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }


  Future<void> toggleRestaurantFavourite(
      String restaurantId,
      User currentUser,
      bool toggleFav,
      ) async {
    if (toggleFav) {
      return await addRestaurantToFavorite(restaurantId, currentUser);
    }
    await removeRestaurantFromFavorite(restaurantId, currentUser);
  }

  Future<void> addRestaurantToFavorite(
      String restaurantId,
      User currentUser,
      ) async {
    var oldRestaurantList = restaurantList;
    restaurantList = restaurantList.map((e) {
      if (e.restaurant.restaurant_id.toString() != restaurantId) return e;
      e.usersWhoFavRestaurant = e.usersWhoFavRestaurant..add(Favourite(restaurantId: int.parse(restaurantId), userId: currentUser.user_id));
      return e;
    }).toList();
    notifyListeners();
    try {
      await _favouriteRepo.addFavourite(
        userId: currentUser.user_id.toString(),
        restaurantId: restaurantId,
      );
    } on DefaultException catch (e) {
      restaurantList = oldRestaurantList;
      notifyListeners();
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }

  Future<void> removeRestaurantFromFavorite(
      String restaurantId,
      User currentUser,
      ) async {
    var oldRestaurantList = restaurantList;
    restaurantList = restaurantList.map((e) {
      if (e.restaurant.restaurant_id.toString() != restaurantId) return e;
      e.usersWhoFavRestaurant = e.usersWhoFavRestaurant
          .where((element) => element.userId != currentUser.user_id)
          .toList();
      return e;
    }).toList();
    notifyListeners();
    try {
      await _favouriteRepo.removeFavourite(
        userId: currentUser.user_id.toString(),
        restaurantId: restaurantId,
      );
    } on DefaultException catch (e) {
      restaurantList = oldRestaurantList;
      notifyListeners();
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }
}