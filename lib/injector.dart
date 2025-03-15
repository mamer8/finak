import 'package:dio/dio.dart';
import 'package:finak/features/home/cubit/cubit.dart';
import 'package:finak/features/home/data/repo.dart';
import 'package:finak/features/menu/cubit/cubit.dart';
import 'package:finak/features/menu/data/menu_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/data/login_repo.dart';
import 'package:finak/features/main_screen/cubit/cubit.dart';
import 'package:finak/features/splash/cubit/cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/app_interceptors.dart';
import 'core/api/base_api_consumer.dart';
import 'core/api/dio_consumer.dart';
import 'features/main_screen/data/main_repo.dart';

// import 'features/downloads_videos/cubit/downloads_videos_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> setup() async {
//!-------------------------Declare Cubit-------------------------

  serviceLocator.registerFactory(
    () => SplashCubit(),
  );

  serviceLocator.registerFactory(
    () => LoginCubit(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => MainCubit(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => MenuCubit(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => HomeCubit(
      serviceLocator(),
    ),
  );
//!----------------------------------------------------------------
///////////////////////////////////////////////////////////////////
//!-------------------------Declare Repo---------------------------
  serviceLocator.registerLazySingleton(() => LoginRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => MainRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => MenuRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => HomeRepo(serviceLocator()));

//!----------------------------------------------------------------

  //! External
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  ///! (dio)
  serviceLocator.registerLazySingleton<BaseApiConsumer>(
      () => DioConsumer(client: serviceLocator()));
  serviceLocator.registerLazySingleton(() => AppInterceptors());

  // Dio
  serviceLocator.registerLazySingleton(
    () => Dio(
      BaseOptions(
        contentType: "application/x-www-form-urlencoded",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    ),
  );
}
