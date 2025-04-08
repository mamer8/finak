// To parse this JSON data, do
//
//     final createRoomModel = createRoomModelFromJson(jsonString);

import 'dart:convert';

CreateRoomModel createRoomModelFromJson(String str) => CreateRoomModel.fromJson(json.decode(str));

String createRoomModelToJson(CreateRoomModel data) => json.encode(data.toJson());

class CreateRoomModel {
    String? msg;
    Data? data;
    int? status;

    CreateRoomModel({
        this.msg,
        this.data,
        this.status,
    });

    factory CreateRoomModel.fromJson(Map<String, dynamic> json) => CreateRoomModel(
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
    int? roomId;

    Data({
        this.roomId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        roomId: json["room_id"],
    );

    Map<String, dynamic> toJson() => {
        "room_id": roomId,
    };
}
