import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/user/user_repository.dart';

import '../domain/user/user.dart';

class UserProvider extends ChangeNotifier {
  List<User> users = [];
  final UserRepository _userRepo;

  UserProvider(this._userRepo) {
    (() async {
      await getUsers();
    })();
  }

  Future<void> getUsers() async {
    users = await _userRepo.getAllUsers();
    notifyListeners();
  }

  Future<User> getUserById(String id) async {
    var user = await _userRepo.getUserById(id: id);
    return user;
  }
}