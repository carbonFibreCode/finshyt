import 'package:finshyt/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SuccesType, Params> {
  //params for parameter as every usecase like signup and login are going to have different parameters, name , email , pass for signUp or email, pass for login
  Future<Either<Failure, SuccesType>> call(Params params);
}
