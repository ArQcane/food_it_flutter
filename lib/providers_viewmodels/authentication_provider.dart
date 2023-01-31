import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_it_flutter/data/exceptions/logged_out_exception.dart';
import 'package:food_it_flutter/domain/user/user_repository.dart';

import '../data/exceptions/default_exception.dart';
import '../domain/user/user.dart';

class AuthenticationProvider extends ChangeNotifier {
  final UserRepository _userRepo;
  final BuildContext _context;
  String? token;
  User? user;

  AuthenticationProvider(this._context, this._userRepo) {
    (() async {
      try {
        await retrieveToken();
      } on UnauthenticatedException {
        return;
      }
      await getCurrentLoggedInUser();
    })();
  }

  Future<void> retrieveToken() async {
    token = await _userRepo.retrieveToken();
    notifyListeners();
  }

  Future<void> getCurrentLoggedInUser() async {
    if (token == null) {
      ScaffoldMessenger.of(_context).showSnackBar(
        const SnackBar(
          content: Text("Must be logged in to do this action!"),
        ),
      );
      return;
    }
    user = await _userRepo.validateToken(token: token!);
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    var resultToken = await _userRepo.login(
      username: username,
      password: password,
    );
    await _userRepo.saveToken(token: resultToken);
    token = resultToken;
    await getCurrentLoggedInUser();
  }

  Future<void> register(
      String firstName,
      String lastName,
      String username,
      String password,
      String email,
      int mobileNumber,
      String gender,
      String address,
      String profilePic) async {
    var resultToken = await _userRepo.register(
      firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
      email: email,
      mobileNumber: mobileNumber,
      gender: gender,
      address: address,
      profilePic: profilePic,
    );
    await _userRepo.saveToken(token: resultToken);
    token = resultToken;
    await getCurrentLoggedInUser();
  }

  Future<void> logOut() async {
    token = null;
    user = null;
    await _userRepo.removeToken();
    notifyListeners();
  }
}
