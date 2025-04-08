// To parse this JSON data, do
//
//     final addMessageModel = addMessageModelFromJson(jsonString);

import 'dart:convert';

import 'package:finak/features/chat/data/models/get_messages_model.dart';

AddMessageModel addMessageModelFromJson(String str) => AddMessageModel.fromJson(json.decode(str));

String addMessageModelToJson(AddMessageModel data) => json.encode(data.toJson());

class AddMessageModel {
    String? msg;
    MessageModel? data;
    int? status;

    AddMessageModel({
        this.msg,
        this.data,
        this.status,
    });

    factory AddMessageModel.fromJson(Map<String, dynamic> json) => AddMessageModel(
        msg: json["msg"],
        data: json["data"] == null ? null : MessageModel.fromJson(json["data"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "status": status,
    };
}
