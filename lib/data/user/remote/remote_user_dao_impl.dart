import 'dart:convert';

import 'package:food_it_flutter/data/user/remote/remote_user_dao.dart';
import 'package:food_it_flutter/domain/user/user.dart';
import 'package:http/http.dart';

import '../../exceptions/default_exception.dart';
import '../../exceptions/field_exception.dart';
import '../../exceptions/logged_out_exception.dart';
import '../../utils/network_utils.dart';

class RemoteUserDaoImpl extends NetworkUtils implements RemoteUserDao {
  RemoteUserDaoImpl() : super(path: "/users");

  @override
  Future<void> deleteUser({
    required String userId,
  }) async {
    var response = await delete(
      createUrl(endpoint: '/deleteuser/$userId'),
    );
    if (response.statusCode == 200) return;
    var body = jsonDecode(response.body);
    if (response.statusCode == 400) {
      throw FieldException.fromJson(body);
    }
    throw DefaultException.fromJson(body);
  }

  @override
  Future<List<User>> getAllUsers() async {
    var response = await get(createUrl());
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => User.fromJson(e)).toList();
  }

  @override
  Future<User> getUserById({required String id}) async {
    var response = await get(createUrl(endpoint: "/id/$id"));
    var body = jsonDecode(response.body);
    if (body == null) {
      throw DefaultException(error: "No user with id $id found");
    }
    return User.fromJson(body);
  }

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    var response = await post(
      createUrl(endpoint: "/login"),
      body: {
        "username": username,
        "user_pass": password,
      },
    );
    if (response.statusCode == 400) {
      throw FieldError.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    var token = body["result"];
    if (token == null) {
      throw DefaultException(error: "Unknown error has occurred");
    }
    return token;
  }

  @override
  Future<String> register(
      {required String firstName,
      required String lastName,
      required String username,
      required String password,
      required String email,
      required int mobileNumber,
      required String gender,
      required String address,
      required String profilePic}) async {
    var response = await post(createUrl(endpoint: "/register"), body: {
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "user_pass": password,
      "gender": gender,
      "mobile_number": mobileNumber,
      "email": email,
      "address": address,
      "profile_pic": profilePic
    });
    if (response.statusCode == 400) {
      throw FieldError.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    var token = body["token"];
    if (token == null) {
      throw DefaultException(error: "Unknown error has occurred");
    }
    return token;
  }

  @override
  Future<String> resetPassword({required String email}) async {
    var response = await post(
      createUrl(endpoint: "/forget-password"),
      body: {"email": email},
    );
    if (response.statusCode == 400) {
      throw FieldError.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    var message = body["message"];
    if (message == null) {
      throw DefaultException(error: "Unknown error has occurred");
    }
    return message;
  }

  @override
  Future<String> updateUserCredentials(
      {String? userId,
      String? firstName,
      String? lastName,
      int? mobileNumber,
      String? address,
      String? profilePic,
      bool? deleteProfilePic}) async {
    var request = MultipartRequest("PUT", createUrl(endpoint: "/updateuser"));
    int length = 0;
    if (firstName != null) {
      request.fields["first_name"] = firstName;
      length += 1;
    }
    if (lastName != null) {
      request.fields["last_name"] = lastName;
      length += 1;
    }
    if (mobileNumber != null) {
      request.fields["mobile_number"] = mobileNumber.toString();
      length += 1;
    }
    if (address != null) {
      request.fields["address"] = address;
      length += 1;
    }
    if (profilePic != null) {
      request.fields["profile_pic"] = profilePic;
      length += 1;
    }
    if (length == 0) {
      throw DefaultException(error: "Must have at least one field to update!");
    }
    var response = await Response.fromStream(await request.send());
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    var token = body["token"];
    if (token == null) {
      throw DefaultException(error: "Unknown error has occurred");
    }
    return token;
  }

  @override
  Future<User> validateToken({required String token}) async {
    var response = await get(
      createUrl(endpoint: "/members/$token"),
    );
    if (response.statusCode != 200) {
      throw UnauthenticatedException();
    }
    var body = jsonDecode(response.body);
    return User.fromJson(body);
  }
}
