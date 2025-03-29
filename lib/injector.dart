import 'package:dio/dio.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/data/login_repo.dart';
import 'package:finak/features/add_offer/cubit/cubit.dart';
import 'package:finak/features/add_offer/data/repo.dart';
import 'package:finak/features/favorite/cubit/cubit.dart';
import 'package:finak/features/favorite/data/repo.dart';
import 'package:finak/features/home/cubit/cubit.dart';
import 'package:finak/features/home/data/repo.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/location/data/repo.dart';
import 'package:finak/features/main_screen/cubit/cubit.dart';
import 'package:finak/features/menu/cubit/cubit.dart';
import 'package:finak/features/menu/data/menu_repo.dart';
import 'package:finak/features/my_offers/cubit/cubit.dart';
import 'package:finak/features/my_offers/data/repo.dart';
import 'package:finak/features/notifications/cubit/cubit.dart';
import 'package:finak/features/notifications/data/repo.dart';
import 'package:finak/features/on_boarding/cubit/onboarding_cubit.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:finak/features/profile/data/repo.dart';
import 'package:finak/features/services/cubit/cubit.dart';
import 'package:finak/features/services/data/repo.dart';
import 'package:finak/features/splash/cubit/cubit.dart';
import 'package:get_it/get_it.dart';
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
    () => OnboardingCubit(),
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

  serviceLocator.registerFactory(
    () => ServicesCubit(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddOfferCubit(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => LocationCubit(
         serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => FavoritesCubit(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => MyOffersCubit(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => ProfileCubit(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => NotificationsCubit(
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

  serviceLocator.registerLazySingleton(() => ServicesRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddOfferRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => MyOffersRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FavoritesRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ProfileRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LocationRepo(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => NotificationsRepo(serviceLocator()));

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
