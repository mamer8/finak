import 'package:finak/core/exports.dart';

import 'models/service_types_model.dart';
import 'models/sub_service_types_model.dart';

class ServicesRepo {
  BaseApiConsumer api;
  ServicesRepo(this.api);
  Future<Either<Failure, GetServiceTypesModel>> getServiceTypes() async {
    try {
      var response = await api.get(EndPoints.getServiceTypesUrl);
      return Right(GetServiceTypesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
}
