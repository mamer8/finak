// To parse this JSON data, do
//
//     final getMessagesModel = getMessagesModelFromJson(jsonString);

import 'dart:convert';

GetMessagesModel getMessagesModelFromJson(String str) => GetMessagesModel.fromJson(json.decode(str));

String getMessagesModelToJson(GetMessagesModel data) => json.encode(data.toJson());

class GetMessagesModel {
    String? msg;
    List<MessageModel>? data;
    int? status;

    GetMessagesModel({
        this.msg,
        this.data,
        this.status,
    });

    factory GetMessagesModel.fromJson(Map<String, dynamic> json) => GetMessagesModel(
        msg: json["msg"],
        data: json["data"] == null ? [] : List<MessageModel>.from(json["data"]!.map((x) => MessageModel.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
    };
}

class MessageModel {
    int? id;
    String? message;
    int? type;
    int? roomId;
    int? isMe;
    int? isSeen;
    String? createdAt;

    MessageModel({
        this.id,
        this.message,
        this.type,
        this.roomId,
        this.isMe,
        this.isSeen,
        this.createdAt,
    });

    factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        message: json["message"],
        type: json["type"],
        roomId: json["room_id"],
        isMe: json["is_me"],
        isSeen: json["is_seen"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "type": type,
        "room_id": roomId,
        "is_me": isMe,
        "is_seen": isSeen,
        "created_at": createdAt,
    };
}
