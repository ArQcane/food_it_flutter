import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/review/review_repository.dart';
import 'package:food_it_flutter/domain/user/user.dart';
import 'package:food_it_flutter/domain/user/user_repository.dart';

import '../data/exceptions/default_exception.dart';
import '../domain/review/review.dart';
import 'authentication_provider.dart';

class TransformedReview {
  Review review;
  User reviewUser;

  TransformedReview({
    required this.review,
    required this.reviewUser,
  });
}


class ReviewProvider extends ChangeNotifier {
  final ReviewRepository _reviewRepo;
  final UserRepository _userRepo;
  final BuildContext _context;
  List<TransformedReview> reviewList = [];

  ReviewProvider(this._context, this._reviewRepo, this._userRepo) {
    getReviews();
  }

  Future<void> getReviews() async {
    try {
      var reviews = await _reviewRepo.getAllReviews()..sort((a, b) {
        return b.dateposted.compareTo(a.dateposted);
      });
      var transformedReview = reviews.map((e) async {
        var user = await _userRepo.getUserById(
          id: e.iduser.toString(),
        );
        return TransformedReview(review: e, reviewUser: user);
      }).toList();
      reviewList = await Future.wait(transformedReview);
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }

  Future<Review> getReviewById(String id) async {
    var review = await _reviewRepo.getReviewsById(id: id);
    return review;
  }

  Future<void> createReview(
    String userId,
    String restaurantId,
    String review,
    int rating,
  ) async {
    try {
      var insertId = await _reviewRepo.createReview(
        userId: userId,
        restaurantId: restaurantId,
        review: review,
        rating: rating,
      );
      var reviewAdded = await _reviewRepo.getReviewsById(id: insertId.toString());
      var reviewUser = await _userRepo.getUserById(
        id: userId.toString(),
      );
      var transformedReview = TransformedReview(review: reviewAdded, reviewUser: reviewUser);
      reviewList = reviewList
        ..add(transformedReview)
        ..sort((a, b) {
          return b.review.dateposted.compareTo(a.review.dateposted);
        });
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }

  Future<void> updateReview(
    String userId,
    String restaurantId,
    String reviewId,
    String review,
    double rating,
  ) async {
    try {
      var reviewUpdated = await _reviewRepo.updateReview(
          reviewId: reviewId,
          idRestaurant: restaurantId,
          idUser: userId,
          review: review,
          rating: rating.toInt());
      print("passes");
      var reviewUser = await _userRepo.getUserById(
        id: userId.toString(),
      );
      var transformedReview = TransformedReview(review: reviewUpdated, reviewUser: reviewUser);
      reviewList = reviewList.map((e) {
        if (e.review.review_id.toString() != reviewId) return e;
        return transformedReview;
      }).toList()
        ..sort((a, b) {
          return b.review.dateposted.compareTo(a.review.dateposted);
        });
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _reviewRepo.deleteReview(
        reviewId: reviewId,
      );
      reviewList = reviewList.where((element) {
        return element.review.review_id.toString() != reviewId;
      }).toList();
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }
}
