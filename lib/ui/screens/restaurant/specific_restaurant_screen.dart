import 'package:flutter/material.dart';

class SpecificRestaurantScreen extends StatefulWidget {
  final String restaurantId;

  const SpecificRestaurantScreen({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<SpecificRestaurantScreen> createState() =>
      _SpecificRestaurantScreenState();
}

class _SpecificRestaurantScreenState extends State<SpecificRestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
