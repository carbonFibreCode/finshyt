// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';

class UserPasswordReset implements Usecase<void, UserPasswordResetParams> {
  final AuthRepository authRepository;
  UserPasswordReset({
    required this.authRepository,
  });
  @override
  Future<Either<Failure, void>> call(UserPasswordResetParams params) async {
    return await authRepository.sendPasswordReset(toEmail: params.email);
  }
}

class UserPasswordResetParams {
  final String email;
  UserPasswordResetParams({
    required this.email,
  });
}
