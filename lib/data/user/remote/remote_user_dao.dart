import 'dart:io';

import '../../../domain/user/user.dart';

abstract class RemoteUserDao {
  Future<List<User>> getAllUsers();
  Future<User> getUserById({required String id});
  Future<User> validateToken({required String token});
  Future<String> resetPassword({required String email});
  Future<void> deleteUser({
    required String userId,
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