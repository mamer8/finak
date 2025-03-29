import 'package:finak/core/exports.dart';
import 'package:flutter_svg/svg.dart';

class CustmMenuRow extends StatelessWidget {
  const CustmMenuRow({
    super.key,
    required this.assetName,
    required this.title,
    this.onTap,
    this.isLast = false,
    this.withRow = true,
  });
  final String assetName;
  final String title;
  final void Function()? onTap;
  final bool isLast;
  final bool withRow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h * 2, horizontal: 21.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                assetName,
                width: 25.w,
                height: 25.w,
              ),
              15.w.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: getMediumStyle(fontSize: 18.sp),
                ),
              ),
              if (withRow)
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
