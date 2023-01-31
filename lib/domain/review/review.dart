class Review {
  late int review_id;
  late int idrestaurant;
  late int iduser;
  late String review;
  late double rating;
  late DateTime dateposted;

  Review({
    required this.review_id,
    required this.idrestaurant,
    required this.iduser,
    required this.review,
    required this.rating,
    required this.dateposted,
  });

  Review.fromJson(Map<String, dynamic> json) {
    review_id = json['review_id'];
    idrestaurant = json['idrestaurant'];
    iduser = json['iduser'];
    review = json['review'];
    rating = json['rating'].toDouble();
    dateposted = DateTime.parse(json['dateposted']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['review_id'] = review_id;
    data['idrestaurant'] = idrestaurant;
    data['iduser'] = iduser;
    data['review'] = review;
    data['rating'] = rating;
    data['dateposted'] = dateposted;
    return data;
  }
}