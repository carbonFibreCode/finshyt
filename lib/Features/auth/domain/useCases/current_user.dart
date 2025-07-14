import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/noParamsClass/no_params.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/core/entities/user.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }

}