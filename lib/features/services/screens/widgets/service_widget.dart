import 'package:finak/core/exports.dart';

class CustomServiceWidget extends StatelessWidget {
  const CustomServiceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      Navigator.pushNamed(context, Routes.servicesDetailsRoute);
      },
      child: Row(
        children: [
          Stack(
            children: [
              CustomNetworkImage(
                image:
                    "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                width: getWidthSize(context) * 0.4,
                height: getHeightSize(context) * 0.18,
                // isService: true,
                borderRadius: 10.w,
              ),
              PositionedDirectional(
                top: 10.h,
                start: 10.w,
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
          Flexible(
            child: Container(
              height: getHeightSize(context) * 0.18,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: BorderDirectional(
                  end: BorderSide(color: AppColors.grey3),
                  top: BorderSide(color: AppColors.grey3),
                  bottom: BorderSide(color: AppColors.grey3),
                  start: BorderSide.none, // No border on top
                ),
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10.r),
                  bottomEnd: Radius.circular(10.r),
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
                    Container(
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
                    Text(
                      "Hotel Name",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(fontSize: 16.sp, fontHeight: 1.2),
                    ),
                    SizedBox(
                      // width: getWidthSize(context) * 0.6,
                      child: AutoSizeText(
                        "5000 \$",
                        maxLines: 2,
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
                            'New York, ANew York, USA',
                            maxLines: 2,
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
          ),
        ],
      ),
    );
  }
}
