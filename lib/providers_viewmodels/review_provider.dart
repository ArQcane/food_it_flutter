import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/review/review_repository.dart';

import '../data/exceptions/default_exception.dart';
import '../domain/review/review.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewRepository _reviewRepo;
  final BuildContext _context;
  List<Review> reviewList = [];

  ReviewProvider(this._context, this._reviewRepo) {
    getReviews();
  }

  Future<void> getReviews() async {
    try {
      reviewList = await _reviewRepo.getAllReviews();
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
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
      var reviewAdded = await _reviewRepo.getReviewsById(id: insertId);
      reviewList = reviewList
        ..add(reviewAdded)
        ..sort((a, b) {
          return b.dateposted.compareTo(a.dateposted);
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
    int rating,
  ) async {
    try {
      var reviewAdded = await _reviewRepo.updateReview(
          reviewId: reviewId,
          idRestaurant: restaurantId,
          idUser: userId,
          review: review,
          rating: rating);
      reviewList = reviewList
        ..add(reviewAdded)
        ..sort((a, b) {
          return b.dateposted.compareTo(a.dateposted);
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
        return element.review_id.toString() != reviewId;
      }).toList();
      notifyListeners();
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
    }
  }
}
