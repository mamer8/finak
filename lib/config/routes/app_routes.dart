import 'package:finak/features/Auth/screens/forgot_password_screen.dart';
import 'package:finak/features/Auth/screens/new_password_screen.dart';
import 'package:finak/features/Auth/screens/otp_screen.dart';
import 'package:finak/features/Auth/screens/sign_up_screen.dart';
import 'package:finak/features/main_screen/screens/main_screen.dart';
import 'package:finak/features/services/screens/services_screen.dart';
import 'package:finak/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_strings.dart';
import '../../features/Auth/screens/login_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String mainRoute = '/main';
  ///////////// Auth /////////////
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signup';

  static const String forgotPasswordRoute = '/forgot_password';
  static const String otpRoute = '/otp';
  static const String newPasswordRoute = '/new_password';
  ///////////// Services /////////////
  static const String servicesRoute = '/services';
}

class AppRoutes {
  static String route = '';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.mainRoute:
        return MaterialPageRoute(
          builder: (context) => MainScreen(),
        );

      ///////////// Auth /////////////
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case Routes.signUpRoute:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );
      case Routes.otpRoute:
        return MaterialPageRoute(
          builder: (context) => const OTPScreen(),
        );
      case Routes.newPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => const NewPasswordScreen(),
        );
      ///////////// Services /////////////
      case Routes.servicesRoute:
        return MaterialPageRoute(
          builder: (context) => const ServicesScreen(),
        );

      // case Routes.detailsRoute:
      //   final service = settings.arguments as ServicesModel;
      //   return MaterialPageRoute(
      //     // Extract the service model argument from the settings arguments map
      //
      //     builder: (context) => Details(service: service),
      //   );
      //

      // return PageTransition(
      //   child: MainScreen(),
      //   type: PageTransitionType.fade,
      //   alignment: Alignment.center,
      //   duration: const Duration(milliseconds: 200),
      // );

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
