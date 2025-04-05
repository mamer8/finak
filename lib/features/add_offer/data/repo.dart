import 'package:dio/dio.dart';
import 'package:finak/core/api/base_api_consumer.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';
import 'package:finak/features/services/data/models/sub_service_types_model.dart';

class AddOfferRepo {
  BaseApiConsumer api;
  AddOfferRepo(this.api);
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

  Future<Either<Failure, DefaultPostModel>> addOffer({
    required String serviceTypeId,
    required String subServiceTypeId,
    required String lat,
    required String long,
    required String locationName,
    required List<String> media,
    required String price,
    required String description,
    required String title,
    required String isPhoneHide,
  }) async {
    try {
      var response = await api.post(EndPoints.addOfferUrl, body: {
        'service_type_id': serviceTypeId,
        'title': title,
        'body': description,
        if (price.isNotEmpty) 'price': price,
        'sub_service_type_id': subServiceTypeId,
        'lat': lat,
        'long': long,
        'location_name': locationName,
        'is_phone_hide': isPhoneHide, //0,1==0:no 1:yes
        for (int i = 0; i < media.length; i++)
          'media[$i]': await MultipartFile.fromFile(media[i]),
      } ,
       formDataIsEnabled: true
      );
      return Right(DefaultPostModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
