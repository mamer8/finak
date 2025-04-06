import 'package:finak/core/exports.dart';

class CustomMessagesCard extends StatelessWidget {
  const CustomMessagesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.chatRoute);
      },
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
                        'AYA OMAR',
                        style: getMediumStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      'Date',
                      style: getRegularStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
                // 5.verticalSpace,
                // Text(
                //   'Notification Description',
                //   style: getRegularStyle(
                //     color: AppColors.grey6,
                //     fontSize: 14.sp,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
