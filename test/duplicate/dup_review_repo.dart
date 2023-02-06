import 'package:food_it_flutter/domain/restaurant/restaurant.dart';
import 'package:food_it_flutter/domain/review/review.dart';
import 'package:food_it_flutter/domain/review/review_repository.dart';
import 'package:food_it_flutter/domain/user/user.dart';

class DuplicateReviewRepo implements ReviewRepository {
  List<Review> _reviews = [];

  DuplicateReviewRepo() {
    _reviews = List.generate(
      10,
      (index) => Review(
        review_id: index,
        review: 'review $index',
        idrestaurant: index,
        iduser: index,
        rating: index.toDouble(),
        dateposted: DateTime.now(),
      ),
    );
  }

  @override
  Future<int> createReview(
      {required String userId,
      required String restaurantId,
      required String review,
      required int rating}) async {
    var reviewAdd = Review(
      review_id: _reviews.length,
      review: review,
      rating: rating.toDouble(),
      idrestaurant: int.parse(restaurantId),
      iduser: 9,
      dateposted: DateTime.now(),
    );
    _reviews.add(reviewAdd);
    return reviewAdd.review_id;
  }

  @override
  Future<void> deleteReview({required String reviewId}) async {
    _reviews.removeWhere((element) => element.review_id == reviewId);
  }

  @override
  Future<List<Review>> getAllReviews() async {
    return _reviews;
  }

  @override
  Future<Review> getReviewsById({required String id}) async {
    return _reviews.firstWhere((element) => element.review_id.toString() == id);
  }

  @override
  Future<List<Review>> getReviewsByRestaurant({required String restaurantId}) async {
    return _reviews
        .where((element) => element.idrestaurant.toString() == restaurantId)
        .toList();
  }

  @override
  Future<List<Review>> getReviewsByUser({required String userId}) async {
    return _reviews.where((element) => element.iduser.toString() == userId).toList();
  }

  @override
  Future<int> getTotalReviewsByUser({required String userId}) {
    // TODO: implement getTotalReviewsByUser
    throw UnimplementedError();
  }

  @override
  Future<Review> updateReview(
      {required String reviewId,
      required String idRestaurant,
      required String idUser,
      String? review,
      int? rating}) async {
    var reviewIndexed = _reviews.firstWhere((element) => element.review_id.toString() == reviewId);
    var updatedReview = Review(
      review_id: reviewIndexed.review_id,
      review: review ?? reviewIndexed.review,
      rating: rating?.toDouble() ?? reviewIndexed.rating,
      idrestaurant: reviewIndexed.idrestaurant,
      iduser: reviewIndexed.iduser,
      dateposted: reviewIndexed.dateposted,
    );
    _reviews = _reviews.map((e) {
      if (e.review_id.toString() == reviewId) {
        return updatedReview;
      }
      return e;
    }).toList();
    return reviewIndexed;
  }
}
