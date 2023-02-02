import 'dart:convert';

import 'package:food_it_flutter/data/review/remote/remote_review_dao.dart';
import 'package:food_it_flutter/data/utils/network_utils.dart';
import 'package:food_it_flutter/domain/review/review.dart';
import 'package:http/http.dart';

import '../../exceptions/default_exception.dart';
import '../../exceptions/field_exception.dart';

class RemoteReviewDaoImpl extends NetworkUtils implements RemoteReviewDao{
  RemoteReviewDaoImpl() : super(path: "/reviews");

  @override
  Future<int> createReview({required String userId, required String restaurantId, required String review, required int rating}) async {
    var response = await post(
      createUrl(endpoint: "/addreview"),
      body: {
        "idrestaurant": restaurantId,
        "iduser": userId,
        "review": review,
        "rating": rating.toString(),
      },
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 400) {
      throw FieldException.fromJson(body);
    }
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(body);
    }
    return body["insertId"];
  }

  @override
  Future<void> deleteReview({required String reviewId}) async {
    var response = await delete(
      createUrl(endpoint: "/deletereview/$reviewId"),
    );
    if (response.statusCode == 200) return;
    var body = jsonDecode(response.body);
    throw DefaultException.fromJson(body);
  }

  @override
  Future<List<Review>> getAllReviews() async {
    var response = await get(createUrl());
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Review.fromJson(e)).toList();
  }

  @override
  Future<Review> getReviewsById({required String id}) async {
    var response = await get(createUrl(endpoint: "/id/$id"));
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    return Review.fromJson(body);
  }

  @override
  Future<List<Review>> getReviewsByRestaurant({required String restaurantId}) async {
    var response = await get(createUrl(endpoint: "/restaurantId/$restaurantId"));
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Review.fromJson(e)).toList();
  }

  @override
  Future<List<Review>> getReviewsByUser({required String userId}) async {
    var response = await get(createUrl(endpoint: "/userId/$userId"));
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body) as List;
    return body.map((e) => Review.fromJson(e)).toList();
  }

  @override
  Future<int> getTotalReviewsByUser({required String userId}) async {
    var response = await get(
      createUrl(endpoint: "/totalReviewsCount/$userId"),
    );
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    var body = jsonDecode(response.body);
    return body["COUNT(review)"];
  }

  @override
  Future<Review> updateReview({required String reviewId, required String idRestaurant, required String idUser, String? review, int? rating}) async {
    var requestBody = <String, dynamic>{};
    var length = 0;
    if (review != null) {
      requestBody["review"] = review;
      length += 1;
    }
    if (rating != null) {
      requestBody["rating"] = rating.toString();
      length += 1;
    }
    requestBody["idrestaurant"] = idRestaurant;
    requestBody["iduser"] = idUser;
    if (length == 0) {
      throw DefaultException(
        error: "Must have at least one field to update!",
      );
    }
    var response = await put(
      createUrl(endpoint: "/updatereviewflutter/$reviewId"),
      body: requestBody,
    );
    if (response.statusCode == 400) {
      throw FieldException.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode != 200) {
      throw DefaultException.fromJson(jsonDecode(response.body));
    }
    return Review.fromJson(jsonDecode(response.body));
  }
}