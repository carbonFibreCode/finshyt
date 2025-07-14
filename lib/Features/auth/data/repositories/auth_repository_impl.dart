import 'package:finshyt/core/error/exceptions.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/Features/auth/data/dataSources/auth_remote_data_sources.dart';
import 'package:finshyt/core/entities/user.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getCurrentUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getCurrentUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        throw ServerExceptions('User not found');
      }
      await remoteDataSource.logout();
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } on sb.AuthException catch (e) {
      return left(Failure('Logout Failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } on sb.AuthException catch (e) {
      return left(Failure('Failed Email verification: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset({
    required String toEmail,
  }) async {
    try {
      await remoteDataSource.sendPasswordReset(toEmail: toEmail);
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } on sb.AuthException catch (e) {
      return left(Failure('Failed to send password reset: ${e.toString()}'));
    }
  }

  Future<Either<Failure, User>> _getCurrentUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } on sb.AuthException catch (e) {
      return left(Failure('Failed to get current user: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
    final user = await remoteDataSource.getCurrentUserData();
      if(user != null){
        return right(user);
      }
      else{
        return left(Failure('User not found'));
      }
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
