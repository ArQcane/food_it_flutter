import 'package:food_it_flutter/data/favourites/remote/remote_favourite_dao.dart';
import 'package:food_it_flutter/domain/favourite/favourite_repository.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant.dart';
import 'package:food_it_flutter/domain/user/user.dart';

class FavouriteRepositoryImpl implements FavouriteRepository{
  final RemoteFavouriteDao _dao;
  FavouriteRepositoryImpl({required RemoteFavouriteDao remoteFavouriteDao}) : _dao = remoteFavouriteDao;

  @override
  Future<String> addFavourite({required String userId, required String restaurantId}) {
    return _dao.addFavourite(userId: userId, restaurantId: restaurantId);
  }

  @override
  Future<List<Restaurant>> getFavouriteRestaurantsOfUser({required String userId}) {
    return _dao.getFavouriteRestaurantsOfUser(userId: userId);
  }

  @override
  Future<List<User>> getUsersWhoFavouriteRestaurant({required String restaurantId}) {
    return _dao.getUsersWhoFavouriteRestaurant(restaurantId: restaurantId);
  }

  @override
  Future<void> removeFavourite({required String userId, required String restaurantId}) {
    return _dao.removeFavourite(userId: userId, restaurantId: restaurantId);
  }
}