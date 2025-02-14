import "dart:convert";

import "package:faithwave_app/src/features/auth/services/auth_service.dart";
import "package:faithwave_app/src/models/errors/auth_error.dart";
import "package:faithwave_app/src/models/user.dart";
import "package:get_it/get_it.dart";
import "package:oxidized/oxidized.dart";
import "package:shared_preferences/shared_preferences.dart";

class LocalUserService implements AuthService {
  late SharedPreferences repository;

  LocalUserService() : repository = GetIt.instance<SharedPreferences>();

  @override
  Future<Result<User, AuthError>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if(users.isEmpty) return Err(AuthErrorInvalidCredentials());

      final user = users.where(
        (u) => u.email == email && u.password == password,
      );

      if (user.isEmpty) {
        return Err(AuthErrorInvalidCredentials());
      }

      await repository.setString("current_user", email);

      return Ok(user.first);
    } on Exception catch(_) {
      return Err(AuthErrorInvalidCredentials());
    }
  }

  @override
  Future<Result<void, AuthError>> signOut() async {
    try {
      await repository.remove("current_user");
      return const Ok(null);
    } on Exception catch(_) {
      return Err(AuthErrorUnknown());
    }
  }

  @override
  Future<Result<User, AuthError>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = User(
        email: email,
        name: name,
        password: password,
      );

      if (users.isNotEmpty) {
        final storeUser = users.where((u) => u.email == email);
        if (storeUser.isNotEmpty) {
          return Err(AuthErrorEmailAlreadyInUse());
        }
      }

      var userList = {...users};
      userList.add(user);

      await repository.setString("current_user", email);

      await repository
        .setStringList("users",
          userList.map((e) => jsonEncode(e.toJson()))
        .toList(),
      );

      return Ok(user);
    } on Exception catch(_) {
      return Err(AuthErrorInvalidCredentials());
    }
  }

  List<User> get users => repository
    .getStringList("users")
    ?.map((e) => User.fromJson(jsonDecode(e)))
    .toList() ?? [];

  @override
  User get currentUser => users.where(
    (u) => u.email == repository.getString("current_user"),
  ).first;
}