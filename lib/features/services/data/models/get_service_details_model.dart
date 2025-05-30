// To parse this JSON data, do
//
//     final getServiceDetailsModel = getServiceDetailsModelFromJson(jsonString);

import 'dart:convert';

GetServiceDetailsModel getServiceDetailsModelFromJson(String str) =>
    GetServiceDetailsModel.fromJson(json.decode(str));

String getServiceDetailsModelToJson(GetServiceDetailsModel data) =>
    json.encode(data.toJson());

class GetServiceDetailsModel {
  String? msg;
  ServiceDataModel? data;
  int? status;

  GetServiceDetailsModel({
    this.msg,
    this.data,
    this.status,
  });

  factory GetServiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetServiceDetailsModel(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : ServiceDataModel.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "status": status,
      };
}

class ServiceDataModel {
  int? id;
  String? title;
  String? body;
  dynamic price;
  int? isPhoneHide;
  String? lat;
  String? long;
  String? locationName;
  bool? isFav;
  int? isOpen;
  int? status;
  List<Media>? media;
  bool? isMine;
  Provider? provider;
  String? serviceType;
  String? subServiceType;

  ServiceDataModel({
    this.id,
    this.title,
    this.body,
    this.price,
    this.isPhoneHide,
    this.lat,
    this.long,
    this.locationName,
    this.isFav,
    this.status,
    this.isOpen,
    this.media,
    this.isMine,
    this.provider,
    this.serviceType,
    this.subServiceType,
  });

  factory ServiceDataModel.fromJson(Map<String, dynamic> json) =>
      ServiceDataModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        price: json["price"],
        isPhoneHide: json["is_phone_hide"],
        lat: json["lat"],
        long: json["long"],
        locationName: json["location_name"],
        isFav: json["is_fav"],
        isOpen: json["is_open"],
        serviceType: json["service_type"],
        subServiceType: json["sub_service_type"],
        status: json["status"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        isMine: json["is_mine"],
        provider: json["provider"] == null
            ? null
            : Provider.fromJson(json["provider"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "price": price,
        "is_phone_hide": isPhoneHide,
        "lat": lat,
        "long": long,
        "location_name": locationName,
        "is_fav": isFav,
        "is_open": isOpen,
        "status": status,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "is_mine": isMine,
        "provider": provider?.toJson(),
        "service_type": serviceType,
        "sub_service_type": subServiceType
      };
}

class Media {
  int? id;
  String? image;

  Media({
    this.id,
    this.image,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class Provider {
  int? id;
  String? name;
  String? image;
  String? postedAt;
  String? phone;
  dynamic email;
  int? roomId;

  Provider({
    this.name,
    this.id,
    this.image,
    this.postedAt,
    this.phone,
    this.email,
    this.roomId,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        name: json["name"],
        id: json["id"],
        image: json["image"],
        postedAt: json["posted_at"],
        phone: json["phone"],
        email: json["email"],
        roomId: json["room_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "image": image,
        "posted_at": postedAt,
        "phone": phone,
        "email": email,
        "room_id": roomId,
      };
}
