import 'package:finak/core/exports.dart';
import 'package:finak/features/services/screens/services_details_screen.dart';

class CustomServiceHomeWidget extends StatelessWidget {
  const CustomServiceHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.servicesDetailsRoute , arguments: ServiceDetailsArgs());
      },
      child: Column(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  CustomNetworkImage(
                    image:
                        "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                    width: getWidthSize(context) * 0.7,
                    height: getHeightSize(context) * 0.18,
                    isService: true,
                    // borderRadius: 10.w,
                  ),
                  PositionedDirectional(
                    bottom: 10.h,
                    start: 10.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 5),
                        child: Text(
                          "sale".tr(),
                          style: getRegularStyle(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 10.h,
                    end: 10.w,
                    child: CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 15.r,
                      child: Icon(
                        Icons.favorite_rounded,
                        color: AppColors.secondGrey,
                        size: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: getHeightSize(context) * 0.11,
                width: getWidthSize(context) * 0.7,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    left: BorderSide(color: AppColors.grey3),
                    right: BorderSide(color: AppColors.grey3),
                    bottom: BorderSide(color: AppColors.grey3),
                    top: BorderSide.none, // No border on top
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Hotel Name",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(fontSize: 16.sp, fontHeight: 1.2),
                      ),
                      SizedBox(
                        width: getWidthSize(context) * 0.6,
                        child: AutoSizeText(
                          "5000 \$",
                          maxLines: 1,
                          minFontSize: 10.sp,
                          // overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                              fontSize: 14.sp, color: AppColors.primary),
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            ImageAssets.locationIcon,
                            width: 15.w,
                          ),
                          5.w.horizontalSpace,
                          Flexible(
                            child: AutoSizeText(
                              'New York, USA',
                              maxLines: 1,
                              minFontSize: 10.sp,
                              style: getRegularStyle(fontSize: 14.sp),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
