// To parse this JSON data, do
//
//     final getRoomsModel = getRoomsModelFromJson(jsonString);

import 'dart:convert';

GetRoomsModel getRoomsModelFromJson(String str) => GetRoomsModel.fromJson(json.decode(str));

String getRoomsModelToJson(GetRoomsModel data) => json.encode(data.toJson());

class GetRoomsModel {
    String? msg;
    List<RoomModel>? data;
    int? status;

    GetRoomsModel({
        this.msg,
        this.data,
        this.status,
    });

    factory GetRoomsModel.fromJson(Map<String, dynamic> json) => GetRoomsModel(
        msg: json["msg"],
        data: json["data"] == null ? [] : List<RoomModel>.from(json["data"]!.map((x) => RoomModel.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
    };
}

class RoomModel {
    int? id;
    int? roomId;
    int? receiverId;
    String? receiverName;
    String? receiverImage;
    String? lastMessage;
    int? type;
    String? createdAt;
    int? isMe;
    int? isSeen;

    RoomModel({
        this.id,
        this.roomId,
        this.receiverId,
        this.receiverName,
        this.receiverImage,
        this.lastMessage,
        this.type,
        this.createdAt,
        this.isMe,
        this.isSeen,
    });

    factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["id"],
        roomId: json["room_id"],
        receiverId: json["receiver_id"],
        receiverName: json["receiver_name"],
        receiverImage: json["receiver_image"],
        lastMessage: json["last_message"],
        type: json["type"],
        createdAt: json["created_at"],
        isMe: json["is_me"],
        isSeen: json["is_seen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "receiver_id": receiverId,
        "receiver_name": receiverName,
        "receiver_image": receiverImage,
        "last_message": lastMessage,
        "type": type,
        "created_at": createdAt,
        "is_me": isMe,
        "is_seen": isSeen,
    };
}
