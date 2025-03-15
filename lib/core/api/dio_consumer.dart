import 'dart:convert';
import 'dart:io';

import 'package:dio/io.dart'; // Updated import
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../error/exceptions.dart';
import 'app_interceptors.dart';
import 'base_api_consumer.dart';
import 'end_points.dart';
import 'package:finak/injector.dart' as injector;

import 'status_code.dart';

class DioConsumer implements BaseApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter)
            .onHttpClientCreate = // Updated class name
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..receiveTimeout = const Duration(minutes: 1)
      ..connectTimeout = const Duration(minutes: 1)
      ..sendTimeout = const Duration(minutes: 1)
      ..validateStatus = (status) {
        return status != null && status < StatusCode.internalServerError;
      };

    client.interceptors.add(injector.serviceLocator<AppInterceptors>());
    client.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
    ));
  }

  @override
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await client.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  @override
  Future<dynamic> post(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    try {
      final response = await client.post(
        path,
        data: formDataIsEnabled ? FormData.fromMap(body!) : body,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  @override
  Future<dynamic> put(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    try {
      final response = await client.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  @override
  Future<dynamic> delete(String path,
      {bool formDataIsEnabled = false,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    try {
      final response = await client.delete(
        path,
        data: formDataIsEnabled ? FormData.fromMap(body!) : body,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioException(error);
    }
  }

  dynamic _handleResponseAsJson(Response<dynamic> response) {
    if (response.data != null) {
      final responseJson = jsonDecode(response.data);
      return responseJson;
    } else {
      throw const FetchDataException();
    }
  }

  void _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const FetchDataException();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.unautherized:
            throw const UnauthorizedException();
          case StatusCode.forbidden:
          case StatusCode.notFound:
            throw const NotFoundException();
          case StatusCode.conflict:
            throw const ConflictException();
          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
          default:
            throw const FetchDataException();
        }
      case DioExceptionType.cancel:
        throw const FetchDataException();
      case DioExceptionType.unknown:
      default:
        throw const NoInternetConnectionException();
    }
  }
}
