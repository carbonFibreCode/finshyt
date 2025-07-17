// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finshyt/core/noParamsClass/no_params.dart';
import 'package:fpdart/src/either.dart';

import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';
class UserEmailVerification implements Usecase<void, NoParams> {
  final AuthRepository authRepository;
  UserEmailVerification({
    required this.authRepository,
  });
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.sendEmailVerification();
  }
}