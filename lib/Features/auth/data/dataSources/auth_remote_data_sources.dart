import 'package:finshyt/core/error/exceptions.dart';
import 'package:finshyt/Features/auth/data/model/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Session? get currentUserSession;
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
  Future<UserModel?> getCurrentUserData();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerExceptions('The User is null');
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession!.user.email);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerExceptions('The User is null');
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      );
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerExceptions('LogOut failed ${e.toString()}');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        throw ServerExceptions('No user found');
      }

      if (user.emailConfirmedAt != null) {
        throw ServerExceptions('User is already verified');
      }

      //resending the email onfirmation
      await supabaseClient.auth.resend(type: OtpType.signup, email: user.email);
    } catch (e) {
      throw ServerExceptions(
        'Failed to send verification email: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(toEmail);
    } catch (e) {
      throw ServerExceptions('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        return UserModel.fromJson(
          userData.first,
        ).copyWith(email: currentUserSession!.user.email);
      }

      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
