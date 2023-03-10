import 'package:food_it_flutter/domain/review/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getAllReviews();
  Future<Review> getReviewsById({required String id});
  Future<List<Review>> getReviewsByUser({required String userId});
  Future<List<Review>> getReviewsByRestaurant({required String restaurantId});
  Future<int> getTotalReviewsByUser({required String userId});
  Future<int> createReview({
    required String userId,
    required String restaurantId,
    required String review,
    required int rating,
  });
  Future<Review> updateReview({
    required String reviewId,
    required String idRestaurant,
    required String idUser,
    String? review,
    int? rating,
  });
  Future<void> deleteReview({
    required String reviewId,
  });
}