// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? msg;
  Data? data;
  int? status;

  LoginModel({
    this.msg,
    this.data,
    this.status,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
  int? id;
  String? name;
  int? notificationCount;
  String? email;
  int? userType;
  int? status;
  int? isSocial;
  String? phone;
  String? image;
  String? jwtToken;

  Data({
    this.id,
    this.name,
    this.notificationCount,
    this.email,
    this.userType,
    this.status,
    this.isSocial,
    this.phone,
    this.image,
    this.jwtToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        notificationCount: json["notification_count"],
        email: json["email"],
        userType: json["user_type"],
        status: json["status"],
        isSocial: json["is_social"],
        phone: json["phone"],
        image: json["image"],
        jwtToken: json["jwt_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "notification_count": notificationCount,
        "email": email,
        "user_type": userType,
        "status": status,
        "is_social": isSocial,
        "phone": phone,
        "image": image,
        "jwt_token": jwtToken,
      };
}
