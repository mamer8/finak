import 'package:finak/core/exports.dart';
import 'package:finak/core/preferences/preferences.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:finak/features/menu/data/models/get_settings_model.dart';

class MenuRepo {
  BaseApiConsumer api;
  MenuRepo(this.api);
  Future<Either<Failure, GetSettingsModel>> getSettings() async {
    try {
      var response = await api.get(
        EndPoints.getSettingsUrl,
      );

      return Right(GetSettingsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

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
