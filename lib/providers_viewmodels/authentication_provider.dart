import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_it_flutter/data/exceptions/logged_out_exception.dart';
import 'package:food_it_flutter/domain/user/user_repository.dart';
import 'package:food_it_flutter/providers_viewmodels/user_provider.dart';

import '../data/exceptions/default_exception.dart';
import '../domain/user/user.dart';

class AuthenticationProvider extends ChangeNotifier {
  final UserRepository _userRepo;
  final UserProvider _userProvider;
  String? token;
  User? user;
  List<User> allUsersInDB = [];

  AuthenticationProvider(this._userRepo,this._userProvider) {
    (() async {
      await getAllUsersInDatabase();
      try {
        await retrieveToken();
      } on UnauthenticatedException {
        return;
      }
      await getCurrentLoggedInUser();
    })();
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
        base64Decode(base64String.replaceAll("data:image/png;base64,", "")
        .replaceAll("data:image/jpeg;base64,", "")),
            fit: BoxFit.fill,
    );
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }


  Future<void> retrieveToken() async {
    token = await _userRepo.retrieveToken();
    notifyListeners();
  }

  Future<void> getCurrentLoggedInUser() async {
    if (token == null) {
      throw UnauthenticatedException();
    }
    user = await _userRepo.validateToken(token: token!);
    notifyListeners();
  }

  Future<void> getAllUsersInDatabase() async {
    try {
      allUsersInDB = await _userRepo.getAllUsers();
      notifyListeners();
    } on DefaultException catch (e) {

    }
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

  Future<void> updateAccountCredentials(String userId, String firstName, String lastName, int mobileNumber, String address, String profilePic) async {

    if (token == null) {
      throw UnauthenticatedException();
    }
    var updatedToken = await _userRepo.updateUserCredentials(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      address: address,
      profilePic: profilePic,
    );
    await getCurrentLoggedInUser();
    _userProvider.users = _userProvider.users.map((e) {
      if (e.user_id == user!.user_id) {
        return user!;
      }
      return e;
    }).toList();
    _userProvider.notifyListeners();
  }

  Future<void> updatePassword(String email) async {
    await _userRepo.resetPassword(
      email: email,
    );
    notifyListeners();
  }
  Future<void> deleteAccount(String userId) async {
    if (token == null) {
      throw UnauthenticatedException();
    }
    await _userRepo.deleteUser(
      userId: userId
    );
    _userProvider.users = _userProvider.users.where((e) {
      return e.user_id != user!.user_id;
    }).toList();
    _userProvider.notifyListeners();
    await logOut();
  }
}
