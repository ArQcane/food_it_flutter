class User {
  late int user_id;
  late String first_name;
  late String last_name;
  late String username;
  late String gender;
  late int mobile_number;
  late String email;
  late String address;
  late String? profile_pic;


  User({
    required this.user_id,
    required this.first_name,
    required this.last_name,
    required this.username,
    required this.gender,
    required this.mobile_number,
    required this.email,
    required this.address,
    required this.profile_pic,
  });

  User.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    username = json['username'];
    gender = json['gender'];
    mobile_number = json['mobile_number'];
    email = json['email'];
    address = json['address'];
    profile_pic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['first_name'] = first_name;
    data['last_name'] = last_name;
    data['username'] = username;
    data['gender'] = gender;
    data['mobile_number'] = mobile_number;
    data['email'] = email;
    data['address'] = address;
    data['profile_pic'] = profile_pic;
    return data;
  }
}