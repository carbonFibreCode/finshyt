import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/core/entities/user.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserLogin implements Usecase<User, UserLoginParams> {
  final AuthRepository authRepository;
  UserLogin( this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({required this.email, required this.password});
}
