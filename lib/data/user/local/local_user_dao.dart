abstract class LocalUserDao {
  Future<String> retrieveToken();
  Future<void> saveToken({required String token});
  Future<void> removeToken();
}