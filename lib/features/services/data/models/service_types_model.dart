// To parse this JSON data, do
//
//     final getServiceTypesModel = getServiceTypesModelFromJson(jsonString);

import 'dart:convert';

GetServiceTypesModel getServiceTypesModelFromJson(String str) =>
    GetServiceTypesModel.fromJson(json.decode(str));

String getServiceTypesModelToJson(GetServiceTypesModel data) =>
    json.encode(data.toJson());

class GetServiceTypesModel {
  String? msg;
  List<ServiceTypeModel>? data;
  int? status;

  GetServiceTypesModel({
    this.msg,
    this.data,
    this.status,
  });

  factory GetServiceTypesModel.fromJson(Map<String, dynamic> json) =>
      GetServiceTypesModel(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<ServiceTypeModel>.from(
                json["data"]!.map((x) => ServiceTypeModel.fromJson(x))),
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

class ServiceTypeModel {
  int? id;
  String? name;
  String? image;

  ServiceTypeModel({
    this.id,
    this.name,
    this.image,
  });

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) =>
      ServiceTypeModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
