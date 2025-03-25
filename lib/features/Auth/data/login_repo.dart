import 'package:finak/core/exports.dart';

import 'models/login_model.dart';

class LoginRepo {
  BaseApiConsumer api;
  LoginRepo(this.api);
  Future<Either<Failure, LoginModel>> login({
    required String password,
    required String phone,
  }) async {
    try {
      var response = await api.post(
        EndPoints.loginUrl,
        body: {
          'password': password,
          'phone': phone,
        },
      );

      return Right(LoginModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, LoginModel>> register({
    required String password,
    required String phone,
    required String name,
    required String email,
    required String passwordConfirmation,
  }) async {
    try {
      var response = await api.post(
        EndPoints.registerUrl,
        body: {
          'name': name,
          'phone': phone,
          if (email.isNotEmpty) 'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return Right(LoginModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, LoginModel>> resetPassword({
    required String password,
    required String phone,
    required String passwordConfirmation,
  }) async {
    try {
      var response = await api.post(
        EndPoints.resetPasswordUrl,
        body: {
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return Right(LoginModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
