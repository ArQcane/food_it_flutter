import 'dart:convert';

import 'package:food_it_flutter/data/exceptions/default_exception.dart';
import 'package:food_it_flutter/data/restaurant/remote/remote_restaurant_dao.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant.dart';
import 'package:http/http.dart';

import '../../utils/network_utils.dart';

class RemoteRestaurantDaoImpl extends NetworkUtils
    implements RemoteRestaurantDao {
  RemoteRestaurantDaoImpl() : super(path: "/restaurants");

  @override
  Future<List<Restaurant>> getAllRestaurants() async {
    var response = await get(createUrl());
    if (response.statusCode != 200) {
      throw DefaultException(
        error: "Unable to get restaurants. Try again later",
      );
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Restaurant.fromJson(e)).toList();
  }

  @override
  Future<List<Restaurant>> getExpensiveRestaurant() async {
    var response = await get(createUrl(endpoint: "/expensive"));
    if (response.statusCode != 200) {
      throw DefaultException(
        error: "Unable to get restaurants. Try again later",
      );
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Restaurant.fromJson(e)).toList();
  }

  @override
  Future<Restaurant> getRestaurantById({required String restaurantId}) async {
    var response = await get(createUrl(endpoint: "/id/$restaurantId"));
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    return Restaurant.fromJson(body);
  }

  @override
  Future<List<Restaurant>> searchRestaurant(String restaurantName) async {
    var response = await post(
      createUrl(endpoint: "/search"),
      body: {"restaurant_name": restaurantName},
    );
    if (response.statusCode != 200) {
      throw DefaultException(
        error: "Unable to get restaurants. Try again later",
      );
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Restaurant.fromJson(e)).toList();
  }

  @override
  Future<List<Restaurant>> sortRestaurantsByAscendingRating() async {
    var response = await get(createUrl(endpoint: "/sort/ascending"));
    if (response.statusCode != 200) {
      throw DefaultException(
        error: "Unable to get restaurants. Try again later",
      );
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Restaurant.fromJson(e)).toList();
  }

  @override
  Future<List<Restaurant>> sortRestaurantsByDescendingRating() async {
    var response = await get(createUrl(endpoint: "/sort/descending"));
    if (response.statusCode != 200) {
      throw DefaultException(
        error: "Unable to get restaurants. Try again later",
      );
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Restaurant.fromJson(e)).toList();
  }
}