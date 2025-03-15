import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart' as trans;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/utils/get_size.dart';
import '../cubit/onboarding_cubit.dart';
import 'onboarding1.dart';
import 'onboarding2.dart';

class OnBoardinScreen extends StatefulWidget {
  const OnBoardinScreen({super.key});

  @override
  State<OnBoardinScreen> createState() => _OnBoardinScreenState();
}

class _OnBoardinScreenState extends State<OnBoardinScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {},
      builder: (context, state) {
        OnboardingCubit cubit = context.read<OnboardingCubit>();
        return OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Flexible(
                    child: PageView(
                      controller: cubit.pageController,
                      reverse: true,
                      onPageChanged: (int page) {
                        cubit.onPageChanged(page);
                      },
                      children: const [
                        OnBoarding1(),
                        OnBoarding3(),
                      ],
                    ),
                  ),
                  SizedBox(height: getWidthSize(context) / 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getWidthSize(context) / 16),
                    child: SmoothPageIndicator(
                      controller: cubit.pageController,
                      count: cubit.numPages,
                      textDirection: TextDirection.ltr,
                      effect: WormEffect(
                        activeDotColor: AppColors.primary,
                        dotColor: AppColors.gray,
                        dotHeight: getWidthSize(context) / 44,
                        dotWidth: getWidthSize(context) / 44,
                        type: WormType.underground,
                      ),
                    ),
                  ),
                  cubit.currentPage == 0
                      ? Column(
                          children: [
                            MaterialButton(
                                minWidth: getWidthSize(context) / 1.2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        getWidthSize(context) / 8)),
                                color: AppColors.primary,
                                onPressed: () {
                                  cubit.pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      curve: Curves.easeInOut);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: getWidthSize(context) / 44,
                                      horizontal: getWidthSize(context) / 44),
                                  padding: EdgeInsets.symmetric(
                                      vertical: getWidthSize(context) / 100,
                                      horizontal: getWidthSize(context) / 32),
                                  decoration: BoxDecoration(
                                      // color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(
                                          getWidthSize(context) / 44)),
                                  child: Text(
                                    trans.tr('next'),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        color: AppColors.white,
                                        fontSize: getWidthSize(context) / 22),
                                  ),
                                )),
                            InkWell(
                                onTap: () async {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.loginRoute);
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setBool('onBoarding', true);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: getWidthSize(context) / 44,
                                      horizontal: getWidthSize(context) / 44),
                                  padding: EdgeInsets.symmetric(
                                      vertical: getWidthSize(context) / 100,
                                      horizontal: getWidthSize(context) / 32),
                                  decoration: BoxDecoration(
                                      // color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(
                                          getWidthSize(context) / 44)),
                                  child: Text(
                                    trans.tr('skip'),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        color: AppColors.primary,
                                        fontSize: getWidthSize(context) / 22),
                                  ),
                                )),
                          ],
                        )
                      : Column(
                          children: [
                            MaterialButton(
                                minWidth: getWidthSize(context) / 1.2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        getWidthSize(context) / 8)),
                                color: AppColors.primary,
                                onPressed: () async {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.loginRoute);
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setBool('HomeState', true);

                                  pref.setBool('onBoarding', true);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: getWidthSize(context) / 44,
                                      horizontal: getWidthSize(context) / 44),
                                  padding: EdgeInsets.symmetric(
                                      vertical: getWidthSize(context) / 100,
                                      horizontal: getWidthSize(context) / 32),
                                  decoration: BoxDecoration(
                                      // color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(
                                          getWidthSize(context) / 44)),
                                  child: Text(
                                    trans.tr('start_now'),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        color: AppColors.white,
                                        fontSize: getWidthSize(context) / 22),
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: getWidthSize(context) / 44,
                                    horizontal: getWidthSize(context) / 44),
                                padding: EdgeInsets.symmetric(
                                    vertical: getWidthSize(context) / 100,
                                    horizontal: getWidthSize(context) / 32),
                                child: Text('')),
                          ],
                        ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.white,
                    child: Image.asset(ImageAssets.topbusinessImage,
                        width: getWidthSize(context) / 3),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
