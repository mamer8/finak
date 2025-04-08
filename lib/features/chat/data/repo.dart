import 'package:dio/dio.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:finak/features/chat/data/models/add_message_model.dart';
import 'package:finak/features/chat/data/models/create_room_model.dart';
import 'package:finak/features/chat/data/models/get_messages_model.dart';
import 'package:finak/features/chat/data/models/get_rooms_model.dart';

class ChatRepo {
  BaseApiConsumer api;
  ChatRepo(this.api);
  Future<Either<Failure, GetRoomsModel>> getMyChats() async {
    try {
      var response = await api.get(EndPoints.getMyChatsUrl);

      return Right(GetRoomsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetMessagesModel>> getMessages(
      {required String roomId}) async {
    try {
      var response = await api.get("${EndPoints.getRoomMessagesUrl}/$roomId");

      return Right(GetMessagesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, AddMessageModel>> sendMessage({
    required String roomId,
    required String messageOrPath,
    required int type,
  }) async {
    try {
      var response = await api.post(EndPoints.sendMessageUrl,
          body: {
            'message': type == 0 // 0 for text, 1 for image
                ? messageOrPath
                : await MultipartFile.fromFile(messageOrPath),
            'room_id': roomId,
            'type': type,
          },
          formDataIsEnabled: true);

      return Right(AddMessageModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CreateRoomModel>> createRoom(
      {required String recieverId}) async {
    try {
      var response = await api.post(EndPoints.createRoomUrl, body: {
        'receiver_id': recieverId,
      });
      return Right(CreateRoomModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
