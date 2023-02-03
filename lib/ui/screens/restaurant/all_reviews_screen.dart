import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/components/reviews/edit_review_dialog.dart';
import 'package:food_it_flutter/ui/components/reviews/review_tab_grphs.dart';
import 'package:provider/provider.dart';

import '../../../data/exceptions/default_exception.dart';
import '../../components/reviews/add_review_form.dart';
import '../../components/reviews/review_card.dart';

class AllReviewsScreen extends StatelessWidget {
  final String restaurantId;

  const AllReviewsScreen({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var reviewProvider = Provider.of<ReviewProvider>(context);
    var reviews = reviewProvider.reviewList
        .where((element) => element.review.idrestaurant.toString() == restaurantId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews!"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Column(
            children: [
              AddReviewForm(restaurantId: restaurantId),
              const SizedBox(height: 10),
              ReviewTabGraphs(reviewsOfRestaurant: reviews),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  var review = reviews[index];
                  return ReviewCard(
                    review: review,
                    width: double.infinity,
                    editReview: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditReviewDialog(reviewObj: review),
                      );
                    },
                    deleteReview: () async {
                      try {
                        await reviewProvider.deleteReview(
                          review.review.review_id.toString(),
                        );
                      } on DefaultException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.error),
                          ),
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              ),
            ],
          )),
    );
  }
}