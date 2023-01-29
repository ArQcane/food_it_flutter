import 'package:food_it_flutter/data/user/local/local_user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserDaoImpl implements LocalUserDao {
  static const String _userKey = "token";
  final SharedPreferences _preferences;

  LocalUserDaoImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  @override
  Future<String> retrieveToken() async {
    var token = _preferences.getString(_userKey);
    if (token == null) throw Exception("Not logged in.");
    return token;
  }

  @override
  Future<void> removeToken() async {
    await _preferences.remove(_userKey);
  }

  @override
  Future<void> saveToken({required String token}) async {
    await _preferences.setString(_userKey, token);
  }
}