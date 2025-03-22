import 'package:finak/core/exports.dart';

class CustomNotificationCard extends StatelessWidget {
  const CustomNotificationCard({
    this.isRead = false,
    super.key,
  });
  final bool isRead;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          width: 1.w,
          color: AppColors.notificationBorder,
        ),
        color: isRead ? AppColors.notificationBG : AppColors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                image: AssetImage(ImageAssets.appIcon),
                fit: BoxFit.cover,
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Notification Title',
                        style: getRegularStyle(),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      'Date',
                      style: getRegularStyle(
                          color: AppColors.primary, fontSize: 14.sp),
                    ),
                  ],
                ),
                5.verticalSpace,
                Text(
                  'Notification Description',
                  style: getRegularStyle(
                    color: AppColors.grey6,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
