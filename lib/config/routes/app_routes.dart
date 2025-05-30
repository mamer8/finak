import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/screens/add_phone_screen.dart';
import 'package:finak/features/Auth/screens/forgot_password_screen.dart';
import 'package:finak/features/Auth/screens/new_password_screen.dart';
import 'package:finak/features/Auth/screens/otp_screen.dart';
import 'package:finak/features/Auth/screens/sign_up_screen.dart';
import 'package:finak/features/add_offer/screens/add_offer_screen.dart';
import 'package:finak/features/add_offer/screens/update_offer_screen.dart';
import 'package:finak/features/chat/screens/chat_screen.dart';
import 'package:finak/features/chat/screens/my_messages_screen.dart';
import 'package:finak/features/favorite/screens/favorite_screen.dart';
import 'package:finak/features/main_screen/screens/main_screen.dart';
import 'package:finak/features/menu/screens/language_screen.dart';
import 'package:finak/features/menu/screens/privacy_policy_screen.dart';
import 'package:finak/features/my_offers/screens/my_offers_screen.dart';
import 'package:finak/features/notifications/screens/notifications_screen.dart';
import 'package:finak/features/on_boarding/screen/onboarding_screen.dart';
import 'package:finak/features/profile/screens/profile_screen.dart';
import 'package:finak/features/profile/screens/change_password_screen.dart';
import 'package:finak/features/services/data/models/get_service_details_model.dart';
import 'package:finak/features/services/screens/services_details_screen.dart';
import 'package:finak/features/services/screens/services_screen.dart';
import 'package:finak/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_strings.dart';
import '../../features/Auth/screens/login_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String onBoardingRoute = '/on_boarding';
  static const String mainRoute = '/main';
  ///////////// Auth /////////////
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signup';

  static const String forgotPasswordRoute = '/forgot_password';
  static const String otpRoute = '/otp';
  static const String newPasswordRoute = '/new_password';
  static const String addPhoneRoute = '/add_phone';
  ///////////// Services /////////////
  static const String servicesRoute = '/services';
  static const String servicesDetailsRoute = '/services_details';
//////////// offers /////////////
  static const String addOfferRoute = '/add_offer';
  static const String updateOfferRoute = '/update_offer';
  static const String myOffersRoute = '/my_offers';
  ////////////// Profile /////////////
  static const String profileRoute = '/profile';
  static const String changePasswordRoute = '/change_password';
  //////////// favorites /////////////
  static const String favoritesRoute = '/favorites';
  //////////// notifications /////////////
  static const String notificationsRoute = '/notifications';
  //////////// Settings /////////////
  static const String languagesRoute = '/languages';
  static const String privacyPolicyRoute = '/privacy_policy';
  ///////////// Chat /////////////
   static const String chatRoute = '/chat';
   static const String messagesRoute = '/messages';

}

class AppRoutes {
  static String route = '';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.onBoardingRoute:
        return MaterialPageRoute(
          builder: (context) => OnBoardinScreen(),
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
         OTPTypes  type = settings.arguments as OTPTypes;
        return MaterialPageRoute(
          builder: (context) =>  OTPScreen(type:  type,),
        );
      case Routes.newPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => const NewPasswordScreen(),
        );
      case Routes.addPhoneRoute:
        return MaterialPageRoute(
          builder: (context) => const AddPhoneScreen(),
        );
      ///////////// Services /////////////
      case Routes.servicesRoute:
      ServicesScreenArgs args = settings.arguments as ServicesScreenArgs;
        return MaterialPageRoute(
          builder: (context) =>  ServicesScreen(
            args: args,
          ),
        );
      case Routes.servicesDetailsRoute:
        final args = settings.arguments as ServiceDetailsArgs;
        return MaterialPageRoute(
          builder: (context) => ServicesDetailsScreen(
            args: args,
          ),
        );
      ////////////// Offers /////////////
      case Routes.addOfferRoute:
        return MaterialPageRoute(
          builder: (context) => const AddOfferScreen(),
        );
      case Routes.updateOfferRoute:
      ServiceDataModel ? serviceDataModel = settings.arguments as ServiceDataModel;
        return MaterialPageRoute(
          builder: (context) =>  UpdateOfferScreen(
            serviceDataModel: serviceDataModel,
          ),
        );
      case Routes.myOffersRoute:
        return MaterialPageRoute(
          builder: (context) => const MyOffersScreen(),
        );
      //////////// Profile /////////////
      case Routes.profileRoute:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );
      case Routes.changePasswordRoute:
        return MaterialPageRoute(
          builder: (context) =>
              const UpdatePasswordScreen.ChangePasswordScreen(),
        );

      //////////// favorites /////////////
      case Routes.favoritesRoute:
        return MaterialPageRoute(
          builder: (context) => const FavoriteScreen(),
        );
      //////////// notifications /////////////
      case Routes.notificationsRoute:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        );
      //////////// Setting /////////////
      case Routes.languagesRoute:
        return MaterialPageRoute(
          builder: (context) => const LanguageSelectionScreen(),
        );
      case Routes.privacyPolicyRoute:
        return MaterialPageRoute(
          builder: (context) => const PrivacyPolicyScreen(),
        );
      //////////// Chat /////////////
      case Routes.chatRoute:
        final args = settings.arguments as ChatScreenArguments;
        return MaterialPageRoute(
          builder: (context) =>  ChatScreen( 
            args: args,
          ),
        );
      case Routes.messagesRoute:
        return MaterialPageRoute(
          builder: (context) => const MyMessagesScreen(),
        );
      // case Routes.messagesRoute:
    
 


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
