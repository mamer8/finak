import 'package:easy_localization/easy_localization.dart';
import 'package:finak/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finak/injector.dart' as injector;
import 'app.dart';
import 'app_bloc_observer.dart';
import 'core/utils/restart_app_class.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await injector.setup();
  Bloc.observer = AppBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark, // status bar icons' color
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('ar', ''), Locale('en', '')],
        path: 'assets/lang',
        saveLocale: true,
        startLocale: const Locale('en', ''),
        fallbackLocale: const Locale('en', ''),
        child: const MyAppWithScreenUtil(),
      ),
    );
  });
}

class MyAppWithScreenUtil extends StatelessWidget {
  const MyAppWithScreenUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // Use MediaQuery to get the current screen size
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final screenHeight = mediaQuery.size.height;
        return ScreenUtilInit(
          designSize: Size(screenWidth, screenHeight),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return HotRestartController(
              child: const MyApp(),
            );
          },
        );
      },
    );
  }
}
