import 'package:finshyt/Features/auth/auth_provider.dart';
import 'package:finshyt/Features/auth/auth_user.dart';
import 'package:finshyt/Features/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> login({required String email, required String password}) => provider
  .login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) => provider.sendPasswordReset(toEmail: toEmail);
  
  @override
  Future<void> reloadUser() => provider.reloadUser();
}
