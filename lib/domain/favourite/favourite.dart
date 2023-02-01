class Favourite {
  late int restaurantId;
  late int userId;

  Favourite({
    required this.restaurantId,
    required this.userId,
  });

  Favourite.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantID'];
    userId = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['restaurantID'] = restaurantId;
    data['userID'] = userId;
    return data;
  }
}