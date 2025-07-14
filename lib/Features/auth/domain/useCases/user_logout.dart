import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/noParamsClass/no_params.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserLogout implements Usecase<void, NoParams> {
  final AuthRepository authRepository;
  UserLogout({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}

