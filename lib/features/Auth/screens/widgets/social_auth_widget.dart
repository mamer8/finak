import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';

import '../../../../core/exports.dart';

class CustomSocialAuthWidget extends StatelessWidget {
  const CustomSocialAuthWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        30.h.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Divider(
                  color: AppColors.primaryGrey,
                  thickness: 1,
                  endIndent: 10,
                ),
              ),
              Text("or".tr(),
                  style: getRegularStyle(
                      fontSize: 18.sp, color: AppColors.primaryGrey)),
              Flexible(
                child: Divider(
                  color: AppColors.primaryGrey,
                  thickness: 1,
                  indent: 10,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.read<LoginCubit>().signInWithGoogle(context);
              },
              child: Image.asset(
                ImageAssets.google,
                width: 60.w,
              ),
            ),
            if (Platform.isIOS) 20.w.horizontalSpace,
            if (Platform.isIOS)
              GestureDetector(
                onTap: () {
                  context.read<LoginCubit>().signInWithApple();
                },
                child: Image.asset(
                  ImageAssets.apple,
                  width: 60.w,
                ),
              ),
            20.w.horizontalSpace,
            GestureDetector(
              onTap: () {
                context.read<LoginCubit>().signInWithFacebook(context);
              },
              child: Image.asset(
                ImageAssets.facebook,
                width: 60.w,
              ),
            ),
          ],
        ),
        30.h.verticalSpace
      ],
    );
  }
}
