import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/review/review.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';

class ReviewTabGraphs extends StatelessWidget {
  final List<TransformedReview> reviewsOfRestaurant;

  const ReviewTabGraphs({
    Key? key,
    required this.reviewsOfRestaurant,
  }) : super(key: key);

  double _getAvgRating(List<TransformedReview> reviewList) {
    if (reviewList.isEmpty) return 0;
    var totalRating = reviewList.fold<double>(
      0,
          (previousValue, element) => previousValue + element.review.rating,
    );
    return totalRating / reviewList.length.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  _getAvgRating(reviewsOfRestaurant).toStringAsFixed(1),
                  style: const TextStyle(
                    color: primary,
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Opacity(
                  opacity: 0.5,
                  child: Text(
                    "out of 5",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                      reviewsOfRestaurant.length.toString() + " reviews"),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...List.generate(
                    5,
                        (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ...List.generate(
                            5 - index,
                                (_) => const Icon(
                              Icons.star,
                              color: primaryAccent,
                              size: 10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                              tween: Tween(
                                begin: 0,
                                end: reviewsOfRestaurant.where((element) {
                                  return element.review.rating == 5 - index;
                                }).length /
                                    reviewsOfRestaurant.length,
                              ),
                              builder: (context, value, _) {
                                return LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: primaryAccent.withAlpha(100),
                                  color: Theme.of(context).colorScheme.primary,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}