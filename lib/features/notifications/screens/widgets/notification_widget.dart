import 'package:finak/core/exports.dart';
import 'package:finak/features/notifications/cubit/cubit.dart';
import 'package:finak/features/notifications/data/models/get_notifications_model.dart';

class CustomNotificationCard extends StatelessWidget {
  const CustomNotificationCard({
    required this.notificationModel,
    super.key,
  });
  final NotificationModel notificationModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NotificationsCubit>().markAsSeen(
              context,
              notificationId: notificationModel.id.toString(),
            );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            width: 1.w,
            color: AppColors.notificationBorder,
          ),
          color: notificationModel.isSeen == 0
              ? AppColors.notificationBG
              : AppColors.white,
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
                          notificationModel.title ?? '',
                          style: getRegularStyle(),
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        notificationModel.createdAt ?? '',
                        style: getRegularStyle(
                            color: AppColors.primary, fontSize: 14.sp),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  Text(
                    notificationModel.body ?? '',
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
      ),
    );
  }
}
