import 'dart:developer';

import 'package:finak/core/exports.dart';
import 'package:finak/features/notifications/cubit/cubit.dart';
import 'package:finak/features/notifications/data/models/get_notifications_model.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/screens/services_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
        log(notificationModel.referenceTable.toString());
        if (notificationModel.isSeen == 0) {
          notificationModel.isSeen = 1;
          context.read<NotificationsCubit>().markAsSeen(
                context,
                notificationId: notificationModel.id.toString(),
              );
        }
        if (notificationModel.referenceTable == 'offers') {
          Navigator.pushNamed(context, Routes.servicesDetailsRoute,
              arguments: ServiceDetailsArgs(
                serviceModel: ServiceModel(
                  id: notificationModel.referenceId,
                ),
              ));
        } else if (notificationModel.referenceTable == 'general_offers' &&
            notificationModel.referenceLink != null) {
          String url = notificationModel.referenceLink ?? '';

          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "notification_details".tr(),
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                content: Text(
                  notificationModel.body ?? "",
                  style: TextStyle(fontSize: 14.sp),
                ),
              );
            },
          );
        }
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
