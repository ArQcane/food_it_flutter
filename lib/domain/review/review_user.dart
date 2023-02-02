class ReviewUser {
  late String username;
  late String profile_pic;

  ReviewUser({
    required this.username,
    required this.profile_pic,
  });

  ReviewUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    profile_pic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['username'] = username;
    data['profile_pic'] = profile_pic;
    return data;
  }
}
