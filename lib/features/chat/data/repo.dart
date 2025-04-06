import 'package:dio/dio.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';

class ChatRepo {
  BaseApiConsumer api;
  ChatRepo(this.api);
  Future<Either<Failure, DefaultPostModel>> getMyMessages() async {
    try {
      var response = await api.get(EndPoints.getMyChatsUrl);
      if (response.statusCode == 200) {
        return Right(DefaultPostModel.fromJson(response.data));
      } else {
        return Left(ServerFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, DefaultPostModel>> getChat(
      {required String roomId}) async {
    try {
      var response = await api.get("${EndPoints.getRoomMessagesUrl}/$roomId");
      if (response.statusCode == 200) {
        return Right(DefaultPostModel.fromJson(response.data));
      } else {
        return Left(ServerFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, DefaultPostModel>> sendMessage({
    required String roomId,
    required String receiverId,
    required String messageOrPath,
    required int type,
  }) async {
    try {
      var response = await api.post(EndPoints.sendMessageUrl, body: {
        'message': type == 0 // 0 for text, 1 for image
            ? messageOrPath
            : await MultipartFile.fromFile(messageOrPath),
        'room_id': roomId,
        'type': type,
        'receiver_id': receiverId,
      });
      if (response.statusCode == 200) {
        return Right(DefaultPostModel.fromJson(response.data));
      } else {
        return Left(ServerFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, DefaultPostModel>> createRoom() async {
    try {
      var response = await api.post(EndPoints.createRoomUrl);
      if (response.statusCode == 200) {
        return Right(DefaultPostModel.fromJson(response.data));
      } else {
        return Left(ServerFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
