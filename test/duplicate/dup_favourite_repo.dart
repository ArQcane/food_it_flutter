import 'package:food_it_flutter/domain/favourite/favourite.dart';
import 'package:food_it_flutter/domain/favourite/favourite_repository.dart';
import 'package:food_it_flutter/domain/restaurant/restaurant.dart';
import 'package:food_it_flutter/domain/user/user.dart';

import 'dup_restaurant_repo.dart';
import 'dup_user_repo.dart';

class DuplicateFavouriteRepo implements FavouriteRepository {
  List<FakeFavorite> _favorites = [];
  final DuplicateUserRepo _userRepo;
  final DuplicateRestaurantRepo _restaurantRepo;

  DuplicateFavouriteRepo(this._userRepo, this._restaurantRepo) {
    _favorites = List.generate(
      10,
          (index) => FakeFavorite(
        id: index.toString(),
        userId: index.toString(),
        restaurantId: index.toString(),
      ),
    );
  }

  FakeFavorite getFavouriteById(String favId) {
    return _favorites.firstWhere((element) => element.id.toString() == favId);
  }

  @override
  Future<String> addFavourite({required String userId, required String restaurantId}) async {
    var favorite = FakeFavorite(
      id: _favorites.length.toString(),
      userId: userId,
      restaurantId: restaurantId,
    );
    _favorites.add(favorite);
    return favorite.id;
  }

  @override
  Future<List<Restaurant>> getFavouriteRestaurantsOfUser({required String userId}) async {
    return _favorites
        .where((element) => element.userId == userId)
        .map(
          (e) => _restaurantRepo.restaurants.firstWhere(
            (element) => element.restaurant_id.toString() == e.restaurantId,
      ),
    )
        .toList();
  }

  Future<Favourite> getUserById({required String id}) async {
    var fakeFav = _favorites.firstWhere((user) => user.userId.toString() == id);
    return Favourite(restaurantId: int.parse(fakeFav.restaurantId), userId: int.parse(fakeFav.userId));
  }

  @override
  Future<List<Favourite>> getUsersWhoFavouriteRestaurant({required String restaurantId}) async {
    return await Future.wait(
      _favorites
          .where((element) => element.restaurantId == restaurantId)
          .map((e) => getUserById(id: e.userId)),
    );
  }

  @override
  Future<void> removeFavourite({required String userId, required String restaurantId}) async {
    _favorites.removeWhere(
          (element) => element.userId == userId && element.restaurantId == restaurantId,
    );
  }
}

class FakeFavorite {
  String id;
  String userId;
  String restaurantId;

  FakeFavorite({
    required this.id,
    required this.userId,
    required this.restaurantId,
  });
}