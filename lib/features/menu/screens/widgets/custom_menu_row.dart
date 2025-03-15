import 'package:finak/core/exports.dart';
import 'package:flutter_svg/svg.dart';

class CustmMenuRow extends StatelessWidget {
  const CustmMenuRow({
    super.key,
    required this.assetName,
    required this.title,
    this.onTap,
  });
  final String assetName;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              assetName,
              width: 30.w,
            ),
            10.w.horizontalSpace,
            Flexible(
              child: Text(
                title,
                style: getMediumStyle(fontSize: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
