// To parse this JSON data, do
//
//     final getHomeModel = getHomeModelFromJson(jsonString);

import 'dart:convert';

import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';

GetHomeModel getHomeModelFromJson(String str) => GetHomeModel.fromJson(json.decode(str));

String getHomeModelToJson(GetHomeModel data) => json.encode(data.toJson());

class GetHomeModel {
    String? msg;
    Data? data;
    int? status;

    GetHomeModel({
        this.msg,
        this.data,
        this.status,
    });

    factory GetHomeModel.fromJson(Map<String, dynamic> json) => GetHomeModel(
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
    List<Slider>? slider;
    List<ServiceTypeModel>? serviceTypes;
    List<ServiceModel>? recommended;

    Data({
        this.slider,
        this.serviceTypes,
        this.recommended,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        slider: json["slider"] == null ? [] : List<Slider>.from(json["slider"]!.map((x) => Slider.fromJson(x))),
        serviceTypes: json["service_types"] == null ? [] : List<ServiceTypeModel>.from(json["service_types"]!.map((x) => ServiceTypeModel.fromJson(x))),
        recommended: json["recommended"] == null ? [] : List<ServiceModel>.from(json["recommended"]!.map((x) => ServiceModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "slider": slider == null ? [] : List<dynamic>.from(slider!.map((x) => x.toJson())),
        "service_types": serviceTypes == null ? [] : List<dynamic>.from(serviceTypes!.map((x) => x.toJson())),
        "recommended": recommended == null ? [] : List<dynamic>.from(recommended!.map((x) => x.toJson())),
    };
}



class Slider {
    int? id;
    String? title;
    String? body;
    String? image;
    String? link;
    String? startDate;
    String? endDate;

    Slider({
        this.id,
        this.title,
        this.body,
        this.image,
        this.link,
        this.startDate,
        this.endDate,
    });

    factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        image: json["image"],
        link: json["link"],
        startDate: json["start_date"],
        endDate: json["end_date"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "image": image,
        "link": link,
        "start_date": startDate,
        "end_date": endDate,
    };
}
