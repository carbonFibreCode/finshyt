import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> sendEmailVerification();
  Future<Either<Failure, void>> sendPasswordReset({required String toEmail});

}
