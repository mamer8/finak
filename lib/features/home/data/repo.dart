
import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';

class HomeRepo {
  BaseApiConsumer api;
  HomeRepo(this.api);

  Future<Either<Failure, DefaultPostModel>> getHomeData() async {
    try {
      var response = await api.get(EndPoints.homeUrl);
      return Right(DefaultPostModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
