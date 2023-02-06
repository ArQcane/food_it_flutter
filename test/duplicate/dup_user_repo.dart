import 'package:food_it_flutter/data/exceptions/logged_out_exception.dart';
import 'package:food_it_flutter/domain/user/user.dart';
import 'package:food_it_flutter/domain/user/user_repository.dart';

class DuplicateUserRepo implements UserRepository {
  String? token = DateTime.now().millisecondsSinceEpoch.toString();
  List<User> users = [];

  DuplicateUserRepo() {
    users = List.generate(
      10,
      (index) => User(
          address: "address$index",
          first_name: "firstName:$index",
          last_name: "lastName$index",
          gender: "M",
          mobile_number: 6587789994,
          profile_pic:
              "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII",
          username: "username $index",
          email: "email$index@gmail.com",
          user_id: index),
    );
  }

  @override
  Future<void> deleteUser({
    required String userId,
  }) async {
    if (token != this.token) {
      throw UnauthenticatedException();
    }
    users.removeLast();
  }

  @override
  Future<List<User>> getAllUsers() async {
    return users;
  }

  @override
  Future<String> retrieveToken() async {
    if (token == null) {
      throw UnauthenticatedException();
    }
    return token!;
  }

  @override
  Future<User> getUserById({required String id}) async {
    return users.firstWhere((user) => user.user_id.toString() == id);
  }

  @override
  Future<User> validateToken({required String token}) async {
    if (token != this.token) {
      throw UnauthenticatedException();
    }
    return users.last;
  }

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    if (username != users.last.username) {
      throw UnauthenticatedException();
    }
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
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
  }) async {
    var user = User(
      user_id: 12,
      first_name: firstName,
      last_name: lastName,
      username: username,
      email: email,
      mobile_number: mobileNumber,
      gender: gender,
      address: address,
      profile_pic: profilePic,
    );
    users.add(user);
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Future<void> removeToken() async {
    token = null;
  }

  @override
  Future<void> saveToken({required String token}) async {
    this.token = token;
  }

  @override
  Future<String> resetPassword({required String email}) async {
    if (users.any((user) => user.email == email)) {
      return "success";
    }
    throw Exception();
  }

  @override
  Future<String> updateUserCredentials(
      {String? userId,
      String? firstName,
      String? lastName,
      int? mobileNumber,
      String? address,
      String? profilePic}) async {
    var updatedUser = User(
      gender: users.last.gender,
      username: users.last.username,
      user_id: users.last.user_id,
      first_name: firstName ?? users.last.first_name,
      last_name: lastName ?? users.last.last_name,
      mobile_number: mobileNumber?? users.last.mobile_number,
      address: address ?? users.last.address,
      email: users.last.email,
      profile_pic: users.last.profile_pic,
    );
    users.removeLast();
    users.add(updatedUser);
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
