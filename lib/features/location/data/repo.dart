import 'dart:convert';

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

  Future<String> getCountryInEnglish(double latitude, double longitude) async {
    const String apiKey = 'AIzaSyCdf4Xjaw_WmHmUa8pphAwLfuH8PQ5mcJk';
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&language=en&key=$apiKey',
    );

    try {
      final data =
          await api.get(url.toString()); // returns already-decoded JSON Map

      if (data['status'] == 'OK') {
        final results = data['results'] as List;

        for (var result in results) {
          final addressComponents = result['address_components'] as List;

          for (var component in addressComponents) {
            final types = component['types'] as List;
            if (types.contains('country')) {
              final country = component['long_name'];
              print("✅ Country: $country");
              return country;
            }
          }
        }
      } else {
        print('❌ Error from API: ${data['status']}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }

    print('❌ Country not found, returning Unknown');
    return 'Unknown';
  }
}
