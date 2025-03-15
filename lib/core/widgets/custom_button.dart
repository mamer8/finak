import 'package:easy_localization/easy_localization.dart';
import 'package:finak/core/exports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.color,
    this.fontColor,
    this.padding,
    this.isDisabled = false,
  });
  final String title;
  final Color? color;
  final Color? fontColor;
  final double? padding;
  final bool isDisabled;

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: GestureDetector(
          onTap: isDisabled ? null : onPressed,
          child: Container(
            // height: 46.h,
            margin: EdgeInsets.symmetric(
                vertical: padding ?? 10.h, horizontal: 20.w),
            padding:
                EdgeInsets.symmetric(vertical: padding ?? 10.h, horizontal: 5),
            decoration: BoxDecoration(
                color: color ?? AppColors.primary,
                borderRadius: BorderRadius.circular(50.r)),
            child: Center(
              child: Text(
                title.tr(),
                style: getBoldStyle(
                    fontweight: FontWeight.w700,
                    color: fontColor ?? AppColors.white,
                    fontSize: 18.sp),
              ),
            ),
          )),
    );
  }
}
