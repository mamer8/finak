import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:finak/features/main_screen/cubit/cubit.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'package:finak/injector.dart' as injector;

import 'features/Auth/cubit/cubit.dart';
import 'features/splash/cubit/cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(text);

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => injector.serviceLocator<SplashCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<LoginCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<MainCubit>(),
          ),
        ],
        child: GetMaterialApp(
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: appTheme(),
          themeMode: ThemeMode.light,
          darkTheme: ThemeData.light(),
          
          // standard dark theme
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ));
  }
}
