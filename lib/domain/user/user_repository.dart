import 'package:food_it_flutter/domain/user/user.dart';

import '../review/review_user.dart';

abstract class UserRepository {
  Future<String> retrieveToken();
  Future<void> saveToken({required String token});
  Future<void> removeToken();
  Future<List<User>> getAllUsers();
  Future<User> getUserById({required String id});
  Future<User> validateToken({required String token});
  Future<String> resetPassword({required String email});
  Future<void> deleteUser({
    required String userId
  });
  Future<String> updateUserCredentials({
    String? userId,
    String? firstName,
    String? lastName,
    int? mobileNumber,
    String? address,
    String? profilePic,
    bool? deleteProfilePic
  });
  Future<String> login({
    required String username,
    required String password,
  });
  Future<String> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required int mobileNumber,
    required String gender,
    required String address,
    required String profilePic,
  });
}