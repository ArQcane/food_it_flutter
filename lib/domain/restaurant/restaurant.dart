import '../../data/utils/network_utils.dart';

class Restaurant {
  late int restaurant_id;
  late String restaurant_name;
  late double average_price_range;
  late double average_rating;
  late String cuisine;
  late String biography;
  late String opening_hours;
  late String region;
  late String restaurant_logo;
  late double location_lat;
  late double location_long;
  late String location;
  late String restaurant_banner;

  Restaurant({
    required this.restaurant_id,
    required this.restaurant_name,
    required this.average_price_range,
    required this.average_rating,
    required this.cuisine,
    required this.biography,
    required this.opening_hours,
    required this.region,
    required this.restaurant_logo,
    required this.location_lat,
    required this.location_long,
    required this.location,
    required this.restaurant_banner,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    restaurant_id = json['restaurant_id'];
    restaurant_name = json['restaurant_name'];
    average_price_range = json['average_price_range'].toDouble();
    average_rating = json['average_rating'].toDouble();
    cuisine = json['cuisine'];
    biography = json['biography'];
    opening_hours = json['opening_hours'];
    region = json['region'];
    restaurant_logo = NetworkUtils.baseUrl + json['restaurant_logo'];
    location_lat = json['location_lat'].toDouble();
    location_long = json['location_long'].toDouble();
    location = json['location'];
    restaurant_banner = json['restaurant_banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant_id'] = restaurant_id;
    data['restaurant_name'] = restaurant_name;
    data['average_price_range'] = average_price_range;
    data['average_rating'] = average_rating;
    data['cuisine'] = cuisine;
    data['biography'] = biography;
    data['opening_hours'] = opening_hours;
    data['region'] = region;
    data['restaurant_logo'] = restaurant_logo;
    data['location_lat'] = location_lat;
    data['location_long'] = location_long;
    data['location'] = location;
    data['restaurant_banner'] = restaurant_banner;
    return data;
  }
}