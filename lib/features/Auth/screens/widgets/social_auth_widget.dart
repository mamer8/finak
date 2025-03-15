import 'package:easy_localization/easy_localization.dart';

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
                  endIndent: 10,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.google,
              width: 60.w,
            ),
            20.w.horizontalSpace,
            Image.asset(
              ImageAssets.apple,
              width: 60.w,
            ),
            20.w.horizontalSpace,
            Image.asset(
              ImageAssets.facebook,
              width: 60.w,
            ),
          ],
        ),
        30.h.verticalSpace
      ],
    );
  }
}
