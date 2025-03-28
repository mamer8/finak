import 'package:finak/core/exports.dart';
import 'package:finak/features/services/data/models/get_service_details_model.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/data/models/sub_service_types_model.dart';

import 'models/service_types_model.dart';

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
  Future<Either<Failure, GetSubServiceTypesModel>> getSubServiceTypes(
      String serviceTypeId) async {
    try {
      var response =
          await api.get(EndPoints.getSubServiceTypesUrl, queryParameters: {
        'service_type_id': serviceTypeId,
      });
      return Right(GetSubServiceTypesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  Future<Either<Failure, GetServicesModel>> getServices(
      {int? serviceTypeId,
      int? subServiceTypeId,
      String? minPrice,
      String? maxPrice,
      required String lat,
      required String long,
      String? type,
      required String search}) async {
    try {
      var response = await api.get(EndPoints.getOffersUrl, queryParameters: {
        if (search.isNotEmpty) 'search': search,
        if (serviceTypeId != null) 'service_type_id': "$serviceTypeId",
        if (subServiceTypeId != null)
          'sub_service_type_id': '$subServiceTypeId',
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (type != null) 'lat': lat,
        if (type != null) 'long': long,
        if (type != null) 'type': type, //asc,desc
      });
      return Right(GetServicesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetServiceDetailsModel>> getServiceDetails(
      {required String offerId}) async {
    try {
      var response = await api.get('${EndPoints.getOfferDetailsUrl}/$offerId');
      return Right(GetServiceDetailsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetServiceDetailsModel>> closeOffer(
      {required String offerId}) async {
    try {
      var response = await api.get('${EndPoints.closeOfferUrl}/$offerId');
      return Right(GetServiceDetailsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
