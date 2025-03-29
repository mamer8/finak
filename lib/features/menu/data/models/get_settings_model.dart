// To parse this JSON data, do
//
//     final getSettingsModel = getSettingsModelFromJson(jsonString);

import 'dart:convert';

GetSettingsModel getSettingsModelFromJson(String str) => GetSettingsModel.fromJson(json.decode(str));

String getSettingsModelToJson(GetSettingsModel data) => json.encode(data.toJson());

class GetSettingsModel {
    String? msg;
    Data? data;
    int? status;

    GetSettingsModel({
        this.msg,
        this.data,
        this.status,
    });

    factory GetSettingsModel.fromJson(Map<String, dynamic> json) => GetSettingsModel(
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "status": status,
    };
}

class Data {
    String? privacy;
    String? phone;
    String? email;

    Data({
        this.privacy,
        this.phone,
        this.email,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        privacy: json["privacy"],
        phone: json["phone"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "privacy": privacy,
        "phone": phone,
        "email": email,
    };
}
