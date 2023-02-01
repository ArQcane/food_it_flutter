import 'dart:convert';
import 'dart:io';

import 'package:food_it_flutter/data/favourites/remote/remote_favourite_dao.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant.dart';
import 'package:food_it_flutter/domain/user/user.dart';
import 'package:http/http.dart';
import '../../../domain/favourite/favourite.dart';
import '../../exceptions/default_exception.dart';
import '../../utils/network_utils.dart';

class RemoteFavouriteDaoImpl extends NetworkUtils implements RemoteFavouriteDao{
  RemoteFavouriteDaoImpl() : super(path: "/favourites");

  @override
  Future<String> addFavourite({required String userId, required String restaurantId}) async {
    var response = await post(
      createUrl(endpoint: "/createFav"),
      body: {
        "userID": userId,
        "restaurantID": restaurantId,
      },
    );
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    return body["message"];
  }

  @override
  Future<List<Restaurant>> getFavouriteRestaurantsOfUser({required String userId}) async {
    var response = await get(createUrl(endpoint: "/user/$userId"));
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Restaurant.fromJson(e)).toList();
  }

  @override
  Future<List<Favourite>> getUsersWhoFavouriteRestaurant({required String restaurantId}) async {
    var response = await get(createUrl(endpoint: "/restaurant/$restaurantId"));
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Favourite.fromJson(e)).toList();
  }

  @override
  Future<void> removeFavourite({required String userId, required String restaurantId}) async {
    var response = await delete(
      createUrl(endpoint: "/deleteFav"),
      body: {
        "userID": userId,
        "restaurantID": restaurantId,
      }
    );
    if (response.statusCode == 200) return;
    throw DefaultException.fromJson(jsonDecode(response.body));
  }
}