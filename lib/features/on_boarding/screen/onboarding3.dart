import 'package:finak/core/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/assets_manager.dart';
import '../../../core/utils/get_size.dart';
import '../cubit/onboarding_cubit.dart';
import 'onboarding1.dart';

class OnBoarding3 extends StatelessWidget {
  const OnBoarding3({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {},
      builder: (context, state) {
        OnboardingCubit cubit = context.read<OnboardingCubit>();
        return Scaffold(
          body: Column(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: ClipPath(
                  clipper: CustomShape(),
                  child: Container(
                    height: getHeightSize(context) * 0.5,
                    width: getWidthSize(context),
                    color: AppColors.grey5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: -getHeightSize(context) * 0.2,
                          child: Image.asset(
                            ImageAssets.introBackgroundImage,
                            width: getWidthSize(context) * 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getWidthSize(context) / 12),
              Container(
                padding: EdgeInsets.all(getWidthSize(context) / 44),
                child: Text(
                  "on_boarding3".tr(),
                  textAlign: TextAlign.center,
                  style: getMediumStyle(color: AppColors.grey4),
                ),
              ),
              SizedBox(height: getWidthSize(context) / 12),
            ],
          ),
        );
      },
    );
  }
}
