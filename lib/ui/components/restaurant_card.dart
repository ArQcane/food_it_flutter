import 'package:flutter/material.dart';

import '../../domain/restaurant/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  restaurant.restaurant_logo,
                ),
              ),
            ),
            Text(restaurant.restaurant_name),
          ],
        ),
      ),
    );
  }
}