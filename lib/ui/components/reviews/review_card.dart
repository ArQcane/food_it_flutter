import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers_viewmodels/review_provider.dart';
import '../../theme/colors.dart';
import '../extras/gradient_text.dart';


class ReviewCard extends StatelessWidget {
  final TransformedReview review;
  final double width;
  final void Function() editReview;
  final void Function() deleteReview;

  const ReviewCard({
    Key? key,
    required this.review,
    required this.width,
    required this.editReview,
    required this.deleteReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var currentUser = authProvider.user;
    var shouldShowEditBtn =
        currentUser != null && currentUser.user_id == review.reviewUser.user_id;

    return Material(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
        ),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: shouldShowEditBtn ? 0 : 4,
                bottom: shouldShowEditBtn ? 0 : 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipOval(
                            child: authProvider.imageFromBase64String(review
                                        .reviewUser.profile_pic ==
                                    null
                                ? "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII"
                                : review.reviewUser.profile_pic!)),
                      ),
                      const SizedBox(width: 5),
                      GradientText(
                        text: review.reviewUser.username,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  if (shouldShowEditBtn)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == "edit") {
                          return editReview();
                        }
                        deleteReview();
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          child: Text("Edit Review"),
                          value: "edit",
                        ),
                        const PopupMenuItem(
                          child: Text("Delete Review"),
                          value: "delete",
                        ),
                      ],
                    )
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              review.review.review,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Column(children: [
              Row(
                children: [
                  Text(
                    review.review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Opacity(
                    opacity: 0.5,
                    child: Text(
                      "/5",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Row(
                    children: List.generate(
                      review.review.rating.toInt(),
                          (index) {
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashRadius: 20,
                              icon: Icon(
                                Icons.star,
                                color: primary,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 5),
            Opacity(
              opacity: 0.5,
              child: Row(
                children: [
                  Text(
                    DateFormat('dd MMM yyyy hh:mm:ss a')
                        .format(review.review.dateposted),
                    style: const TextStyle(
                      fontSize: 18,
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