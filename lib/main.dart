import 'package:finak/core/exports.dart';
import 'package:finak/core/preferences/preferences.dart';
import 'package:finak/firebase_options.dart';
import 'package:finak/notification_service.dart';

import 'package:finak/injector.dart' as injector;
import 'package:finak/core/utils/restart_app_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Dependencies
  await injector.setup();
  Bloc.observer = AppBlocObserver();
  _setSystemUI();

  await _setupSecureStorage();
  // Initialize Notifications
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();

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
}

/// **Set System UI Preferences**
void _setSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// **Sets Up Secure Storage**
Future<void> _setupSecureStorage() async {
  prefs = await SharedPreferences.getInstance();
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  prefs = await SharedPreferences.getInstance();
  storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
}

/// **App Widget with ScreenUtil**
class MyAppWithScreenUtil extends StatelessWidget {
  const MyAppWithScreenUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return HotRestartController(child: const MyApp());
      },
    );
  }
}
