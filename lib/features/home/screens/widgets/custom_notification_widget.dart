import 'package:finak/core/exports.dart';
import 'package:flutter/cupertino.dart';

class CustomNotificationWidget extends StatelessWidget {
  const CustomNotificationWidget({
    super.key,
    required this.count,
  });
  final int count;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.notificationsRoute);
      },
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Icon(
            CupertinoIcons.bell,
            color: AppColors.primary,
            size: 25.sp,
          ),
          if (count != 0)
            PositionedDirectional(
              top: -5.h,
              start: -5.w,
              child: Container(
                // height: 14.h,
                // width: 14.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: getMediumStyle(
                        color: AppColors.white,
                        fontHeight: 1,
                        fontSize: count > 9 ? 10.sp : 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
