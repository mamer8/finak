import 'package:finak/core/exports.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';

class LocationRepo {
  BaseApiConsumer api;
  LocationRepo(this.api);

  Future<Either<Failure, GetServicesModel>> getServices(
      {required String lat,
      required String long,
      required String distance,
      required String search}) async {
    try {
      var response =
          await api.get(EndPoints.getOffersOnMapUrl, queryParameters: {
        if (search.isNotEmpty) 'search': search,

        'lat': lat,
        'long': long,
        'distance': distance, //asc,desc
      });
      return Right(GetServicesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
