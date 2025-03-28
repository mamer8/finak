import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';

class MyOffersRepo {
  BaseApiConsumer api;
  MyOffersRepo(this.api);
  Future<Either<Failure, GetServiceTypesModel>> getServiceTypes() async {
    try {
      var response = await api.get(EndPoints.getServiceTypesUrl);
      return Right(GetServiceTypesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetServicesModel>> getMyOffers(
      {int? serviceTypeId, required String search}) async {
    try {
      var response = await api.get(EndPoints.getMyOffersUrl, queryParameters: {
        if (serviceTypeId != null) 'service_type_id': "$serviceTypeId",
        if (search.isNotEmpty) 'search': search
      });
      return Right(GetServicesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

 
}
