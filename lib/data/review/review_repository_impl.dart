import 'package:food_it_flutter/data/review/remote/remote_review_dao.dart';
import 'package:food_it_flutter/domain/review/review.dart';
import 'package:food_it_flutter/domain/review/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {

  final RemoteReviewDao _dao;

  ReviewRepositoryImpl({required RemoteReviewDao remoteCommentDao})
      : _dao = remoteCommentDao;

  @override
  Future<String> createReview(
      {required String userId, required String restaurantId, required String review, required int rating}) {
    return _dao.createReview(
        userId: userId,
        restaurantId: restaurantId,
        review: review,
        rating: rating
    );
  }

  @override
  Future<void> deleteReview({required String reviewId}) {
    return _dao.deleteReview(reviewId: reviewId);
  }

  @override
  Future<List<Review>> getAllReviews() {
    return _dao.getAllReviews();
  }

  @override
  Future<Review> getReviewsById({required String id}) {
    return _dao.getReviewsById(id: id);
  }

  @override
  Future<List<Review>> getReviewsByRestaurant({required String restaurantId}) {
    return _dao.getReviewsByRestaurant(restaurantId: restaurantId);
  }

  @override
  Future<List<Review>> getReviewsByUser({required String userId}) {
    return _dao.getReviewsByUser(userId: userId);
  }

  @override
  Future<int> getTotalReviewsByUser({required String userId}) {
    return _dao.getTotalReviewsByUser(userId: userId);
  }

  @override
  Future<Review> updateReview(
      {required String reviewId, required String idRestaurant, required String idUser, String? review, int? rating}) {
    return _dao.updateReview(
      reviewId:reviewId,
      idRestaurant:idRestaurant,
      idUser:idUser,
      review:review,
      rating:rating,
    );
  }
}