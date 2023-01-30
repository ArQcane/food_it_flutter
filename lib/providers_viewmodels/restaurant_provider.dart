import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant_repository.dart';

import '../data/exceptions/default_exception.dart';
import '../domain/restaurant/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository _restaurantRepo;
  final BuildContext _context;
  bool isLoading = false;
  List<Restaurant> restaurantList = [];

  RestaurantProvider(this._context, this._restaurantRepo) {
    getRestaurants();
  }

  Future<void> getRestaurants() async {
    isLoading = true;
    notifyListeners();
    try {
      restaurantList = await _restaurantRepo.getAllRestaurants();
      isLoading = false;
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }


}