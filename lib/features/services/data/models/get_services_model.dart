// To parse this JSON data, do
//
//     final getServicesModel = getServicesModelFromJson(jsonString);

import 'dart:convert';

GetServicesModel getServicesModelFromJson(String str) =>
    GetServicesModel.fromJson(json.decode(str));

String getServicesModelToJson(GetServicesModel data) =>
    json.encode(data.toJson());

class GetServicesModel {
  String? msg;
  List<ServiceModel>? data;
  int? status;

  GetServicesModel({
    this.msg,
    this.data,
    this.status,
  });

  factory GetServicesModel.fromJson(Map<String, dynamic> json) =>
      GetServicesModel(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<ServiceModel>.from(
                json["data"]!.map((x) => ServiceModel.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
      };
}

class ServiceModel {
  int? id;
  String? title;
  String? subServiceType;
  dynamic? price;
  String? lat;
  String? long;
  String? locationName;
  bool? isFav;
  String? logo;
  int? status;

  ServiceModel({
    this.id,
    this.title,
    this.subServiceType,
    this.price,
    this.lat,
    this.long,
    this.locationName,
    this.isFav,
    this.logo,
    this.status,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json["id"],
        title: json["title"],
        subServiceType: json["sub_service_type"],
        price: json["price"],
        lat: json["lat"],
        long: json["long"],
        locationName: json["location_name"],
        isFav: json["is_fav"],
        logo: json["logo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_service_type": subServiceType,
        "price": price,
        "lat": lat,
        "long": long,
        "location_name": locationName,
        "is_fav": isFav,
        "logo": logo,
        "status": status,
      };
}
