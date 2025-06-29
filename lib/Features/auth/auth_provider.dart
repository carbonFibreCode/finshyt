import 'package:finshyt/Features/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initialize();
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> createUser({
    required String email, required String password
  });
  Future<void> reloadUser();
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});

}
