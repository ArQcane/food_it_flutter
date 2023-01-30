import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/user/user_repository.dart';

import '../data/exceptions/default_exception.dart';
import '../domain/user/user.dart';

class AuthenticationProvider extends ChangeNotifier{
  final UserRepository _userRepo;
  final BuildContext _context;
  String? token;
  User? user;

  AuthenticationProvider(this._context, this._userRepo) {
    (() async {
      try {
        await retrieveToken();
      } on DefaultException {
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

  void logOut() {
    token = null;
    user = null;
    notifyListeners();
  }
}