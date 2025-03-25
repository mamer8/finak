import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/core/preferences/preferences.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:finak/features/Auth/data/models/login_model.dart';

class ProfileRepo {
  BaseApiConsumer api;
  ProfileRepo(this.api);
  Future<Either<Failure, LoginModel>> getProfile() async {
    try {
      var response = await api.get(
        EndPoints.profileUrl,
      );

      return Right(LoginModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, DefaultPostModel>> storeFcm() async {
    String? token = Preferences.instance.getNotificationToken();

    log("token =  $token");

    try {
      var response = await api.post(EndPoints.fcmUrl, body: {
        if (token != null) 'token': token,
        'device_type': Platform.isAndroid ? 1 : 2,
      });
      return Right(DefaultPostModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, LoginModel>> updateUserData(
      {required String name, required String email, String? imagePath}) async {
    try {
      var response = await api.post(EndPoints.updateProfileUrl,
          body: {
            'name': name,
            if (email.isNotEmpty) 'email': email,
            if (imagePath != null)
              'image': await MultipartFile.fromFile(imagePath)
          },
          formDataIsEnabled: true);
      return Right(LoginModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, DefaultPostModel>> updatepassword(
      {required String currentPassword,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      var response = await api.post(EndPoints.changePasswordUrl,
          body: {
            'old_password': currentPassword,
            'password': newPassword,
            'password_confirmation': confirmPassword
          },
          formDataIsEnabled: true);
      return Right(DefaultPostModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
