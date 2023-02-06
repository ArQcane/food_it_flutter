import 'package:flutter_test/flutter_test.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/providers_viewmodels/user_provider.dart';

import 'duplicate/dupes.dart';

void main() {
  group('User Provider', () {
    late UserProvider provider;
    late DuplicateUserRepo fakeUserRepo;
    setUpAll(() {
      fakeUserRepo = DuplicateUserRepo();
      provider = UserProvider(fakeUserRepo);
    });

    test('should return a list of users', () async {
      await provider.getUsers();
      expect(provider.users, isNotEmpty);
      expect(provider.users.length, fakeUserRepo.users.length);
    });

    test("should return one user if id is valid", () async {
      var user = await provider.getUserById("1");
      expect(user, isNotNull);
      expect(user.user_id, "1");
    });
  });

  group('Auth Provider', () {
    late AuthenticationProvider authProvider;
    late UserProvider userProvider;
    late DuplicateUserRepo fakeUserRepo;
    setUpAll(() {
      fakeUserRepo = DuplicateUserRepo();
      userProvider = UserProvider(fakeUserRepo);
      authProvider = AuthenticationProvider(fakeUserRepo, userProvider);
    });

    test('should return a token', () async {
      await authProvider.retrieveToken();
      expect(authProvider.token, isNotNull);
      expect(authProvider.token == fakeUserRepo.token, isTrue);
    });

    test('should return a user', () async {
      await authProvider.getCurrentLoggedInUser();
      expect(authProvider.user, isNotNull);
      expect(authProvider.user!.user_id, fakeUserRepo.users.last.user_id);
    });

    test(
      'When login, with valid credentials, should update token',
          () async {
        var oldToken = authProvider.token;
        var lastUser = fakeUserRepo.users.last;
        await authProvider.login(lastUser.username, "fasdfasdfasdf");
        expect(authProvider.token, isNotNull);
        expect(authProvider.token, isNot(oldToken));
      },
    );

    test(
      'When logout, should update token and users',
          () async {
        var oldToken = authProvider.token;
        await authProvider.logOut();
        expect(authProvider.token, isNull);
        expect(authProvider.token, isNot(oldToken));
        expect(authProvider.user, isNull);
        expect(userProvider.users.length, fakeUserRepo.users.length);
      },
    );
  });
}