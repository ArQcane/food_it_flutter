import 'package:food_it_flutter/data/user/remote/remote_user_dao.dart';
import 'package:food_it_flutter/domain/user/user.dart';
import 'package:food_it_flutter/domain/user/user_repository.dart';

import 'local/local_user_dao.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteUserDao _remoteUserDao;
  final LocalUserDao _localUserDao;

  UserRepositoryImpl({
    required RemoteUserDao remoteUserDao,
    required LocalUserDao localUserDao,
  })  : _remoteUserDao = remoteUserDao,
        _localUserDao = localUserDao;

  @override
  Future<void> deleteUser({required String userId}) {
    return _remoteUserDao.deleteUser(
      userId: userId
    );
  }

  @override
  Future<List<User>> getAllUsers() {
    return _remoteUserDao.getAllUsers();
  }

  @override
  Future<User> getUserById({required String id}) {
     return _remoteUserDao.getUserById(id: id);
  }

  @override
  Future<String> login({required String username, required String password}) {
    return _remoteUserDao.login(username: username, password: password);
  }

  @override
  Future<String> register({required String firstName, required String lastName, required String username, required String password, required String email, required int mobileNumber, required String gender, required String address, required String profilePic}) {
    return _remoteUserDao.register(
        firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
      email: email,
      mobileNumber: mobileNumber,
      gender: gender,
      address: address,
      profilePic: profilePic,
    );
  }

  @override
  Future<void> removeToken() {
    return _localUserDao.removeToken();
  }

  @override
  Future<String> resetPassword({required String email}) {
    return _remoteUserDao.resetPassword(email: email);
  }

  @override
  Future<String> retrieveToken() {
    return _localUserDao.retrieveToken();
  }

  @override
  Future<void> saveToken({required String token}) {
    return _localUserDao.saveToken(token: token);
  }

  @override
  Future<String> updateUserCredentials({String? userId, String? firstName, String? lastName, int? mobileNumber, String? address, String? profilePic, bool? deleteProfilePic}) {
    return _remoteUserDao.updateUserCredentials(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      address: address,
      profilePic: profilePic,
      deleteProfilePic: deleteProfilePic,
    );
  }

  @override
  Future<User> validateToken({required String token}) {
    return _remoteUserDao.validateToken(token: token);
  }
  
}