import 'dart:developer';

import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:finak/features/notifications/data/models/get_notifications_model.dart';

class NotificationsRepo {
  BaseApiConsumer api;
  NotificationsRepo(this.api);

  Future<Either<Failure, GetNotificationsModel>> getNotifications() async {
    try {
      var response = await api.get(EndPoints.getNotificationsUrl);
   
      return Right(GetNotificationsModel.fromJson(response));
   
    } on ServerException {
      return Left(ServerFailure());
    }
  }


  Future<Either<Failure, DefaultPostModel>> markAsSeen(
      {required String notificationId}) async {
    try {
      var response = await api.post(EndPoints.markAsSeenUrl, body: {
        'notification_id': notificationId,
      });

      return Right(DefaultPostModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
