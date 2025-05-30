import 'package:finak/core/exports.dart';
import 'package:finak/features/home/data/model/home_model.dart';

class HomeRepo {
  BaseApiConsumer api;
  HomeRepo(this.api);

  Future<Either<Failure, GetHomeModel>> getHomeData({String? country}) async {
    try {
      var response = await api.get(EndPoints.homeUrl, queryParameters: {
        if (country != null && country != 'Unknown') 'country': country,
      });
      return Right(GetHomeModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
