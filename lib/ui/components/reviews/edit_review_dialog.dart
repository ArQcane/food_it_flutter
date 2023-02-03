import 'package:flutter/material.dart';
import 'package:food_it_flutter/domain/review/review.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/review_provider.dart';
import 'package:food_it_flutter/ui/components/extras/action_button.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';

import '../../../data/exceptions/default_exception.dart';
import '../../../data/exceptions/field_exception.dart';

class EditReviewDialog extends StatefulWidget {
  final TransformedReview reviewObj;

  const EditReviewDialog({
    Key? key,
    required this.reviewObj,
  }) : super(key: key);

  @override
  State<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  String review = "";
  double rating = 0;
  String? reviewError;
  String? ratingError;
  bool isLoading = false;

  bool _validateRating() {
    if (rating != 0) return true;
    setState(() {
      ratingError = "Rating required!";
    });
    return false;
  }

  void submit() async {
    FocusScope.of(context).unfocus();
    var isReviewValid = _formKey.currentState!.validate();
    var isRatingValid = _validateRating();
    if (!isReviewValid || !isRatingValid) return;
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    try {
      var reviewProvider = Provider.of<ReviewProvider>(
        context,
        listen: false,
      );
      var user = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      ).user!;
      await reviewProvider.updateReview(
        user.user_id.toString(),
        widget.reviewObj.review.idrestaurant.toString(),
        widget.reviewObj.review.review_id.toString(),
        review,
        rating,
      );
    } on FieldException catch (e) {
      var reviewError = e.fieldErrors.where(
            (element) => element.field == "review",
      );
      var ratingError = e.fieldErrors.where(
            (element) => element.field == "rating",
      );
      if (reviewError.isNotEmpty) {
        setState(() {
          this.reviewError = reviewError.first.error;
        });
      }
      if (ratingError.isNotEmpty) {
        setState(() {
          this.ratingError = ratingError.first.error;
        });
      }
      setState(() {
        isLoading = false;
      });
      return;
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    _formKey.currentState!.reset();
    setState(() {
      isLoading = false;
      review = "";
      rating = 0;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        review = widget.reviewObj.review.review;
        rating = widget.reviewObj.review.rating.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 64;

    return Center(
      child: FittedBox(
        child: Material(
          elevation: 4,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Review",
                      border: const OutlineInputBorder(),
                      errorText: reviewError,
                    ),
                    initialValue: widget.reviewObj.review.review,
                    onChanged: (_) {
                      if (reviewError == null) return;
                      setState(() {
                        reviewError = null;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Review required!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        review = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (rect) {
                          return LinearGradient(
                            colors: ratingError != null
                                ? [Colors.red, Colors.red]
                                : [primaryAccent, primary],
                          ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                                (index) {
                              return Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        ratingError = null;
                                        if (rating == index + 1 &&
                                            rating != 1) {
                                          rating--;
                                          return;
                                        }
                                        rating = index + 1;
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    splashRadius: 20,
                                    icon: Icon(
                                      rating >= index + 1
                                          ? Icons.star
                                          : Icons.star_border_outlined,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ActionButton(
                          onClick: submit,
                          isLoading: isLoading,
                          text: "Submit",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (ratingError != null)
                    Text(
                      ratingError!,
                      style:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}