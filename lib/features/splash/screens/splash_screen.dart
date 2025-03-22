import 'dart:async';
import 'package:finak/core/exports.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:finak/core/utils/assets_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../core/utils/dialogs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Timer _timer;

  _startDelay() async {
    _timer = Timer(
      const Duration(seconds: 3, milliseconds: 500),
      () {
        _getStoreUser();
      },
    );
  }

  Future<void> _getStoreUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('onBoarding') != null) {
      if (prefs.getString('user') != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.mainRoute, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.loginRoute,
          (route) => false,
        );
      }
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.onBoardingRoute,

        ///onBprading
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // context.read<SplashCubit>().getAdsOfApp();
context
            .read<LocationCubit>()
            .checkAndRequestLocationPermission(context);
    _startDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(getWidthSize(context) * 0.15),
              child: Image.asset(
                ImageAssets.logoWithTextImage,
                // height: getSize(context) / 1.2,
                // width: getSize(context) / 1.2,
              ),
            ),
          ),
        ],
      ),
    );
    //   },
    // );
  }
}
