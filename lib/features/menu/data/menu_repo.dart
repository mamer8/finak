import 'package:finak/core/exports.dart';
import 'package:finak/core/preferences/preferences.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';

class MenuRepo {
  BaseApiConsumer api;
  MenuRepo(this.api);
  Future<Either<Failure, DefaultPostModel>> logout() async {
    String? token = Preferences.instance.getNotificationToken();
    try {
      var response = await api.post(
        EndPoints.logoutUrl,
        body: {
          'token': token,
        },
      );

      return Right(DefaultPostModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, DefaultPostModel>> deleteAccount() async {
    try {
      var response = await api.post(
        EndPoints.deleteAccountUrl,
      );

      return Right(DefaultPostModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
