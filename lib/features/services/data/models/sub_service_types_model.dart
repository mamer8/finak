// To parse this JSON data, do
//
//     final getSubServiceTypesModel = getSubServiceTypesModelFromJson(jsonString);

import 'dart:convert';

GetSubServiceTypesModel getSubServiceTypesModelFromJson(String str) =>
    GetSubServiceTypesModel.fromJson(json.decode(str));

String getSubServiceTypesModelToJson(GetSubServiceTypesModel data) =>
    json.encode(data.toJson());

class GetSubServiceTypesModel {
  String? msg;
  List<SubServiceTypeModel>? data;
  int? status;

  GetSubServiceTypesModel({
    this.msg,
    this.data,
    this.status,
  });

  factory GetSubServiceTypesModel.fromJson(Map<String, dynamic> json) =>
      GetSubServiceTypesModel(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<SubServiceTypeModel>.from(
                json["data"]!.map((x) => SubServiceTypeModel.fromJson(x))),
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

class SubServiceTypeModel {
  int? id;
  String? serviceType;
  String? name;

  SubServiceTypeModel({
    this.id,
    this.serviceType,
    this.name,
  });

  factory SubServiceTypeModel.fromJson(Map<String, dynamic> json) =>
      SubServiceTypeModel(
        id: json["id"],
        serviceType: json["service_type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_type": serviceType,
        "name": name,
      };
}
