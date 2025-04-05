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
  Data? data;
  int? status;

  GetServiceDetailsModel({
    this.msg,
    this.data,
    this.status,
  });

  factory GetServiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetServiceDetailsModel(
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

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  String? name;
  String? image;
  String? postedAt;
  String? phone;
  dynamic email;

  Provider({
    this.name,
    this.image,
    this.postedAt,
    this.phone,
    this.email,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        name: json["name"],
        image: json["image"],
        postedAt: json["posted_at"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "posted_at": postedAt,
        "phone": phone,
        "email": email,
      };
}
