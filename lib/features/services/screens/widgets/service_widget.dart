import 'package:finak/core/exports.dart';
import 'package:finak/features/favorite/screens/widgets/fav_button.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/screens/services_details_screen.dart';

class CustomServiceWidget extends StatelessWidget {
  const CustomServiceWidget({
    this.isOffers = false,
    this.isFavoriteScreen = false,
    super.key,
    this.serviceModel,
  });
  final bool isOffers;
  final bool isFavoriteScreen;
  final ServiceModel? serviceModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.servicesDetailsRoute,
            arguments: ServiceDetailsArgs(
              serviceModel: serviceModel,
              isFavoriteScreen: isFavoriteScreen,
            ));
      },
      child: Row(
        children: [
          Stack(
            children: [
              CustomNetworkImage(
                image: serviceModel?.logo ??
                    "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                width: getWidthSize(context) * 0.4,
                height: getHeightSize(context) * 0.17,
                // isService: true,
                borderRadius: 10.w,
              ),
              // if (!isOffers)
              PositionedDirectional(
                top: 10.h,
                start: 10.w,
                child: CustomFavButton(
                  isFavoriteScreen: isFavoriteScreen,
                  isFav: serviceModel?.isFav ?? false,
                  serviceId: serviceModel?.id ?? 0,
                ),
              ),
              if (serviceModel?.status != 1)
                PositionedDirectional(
                  bottom: 10.h,
                  end: 10.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: serviceModel?.status == 0
                          ? AppColors.secondGrey
                          : serviceModel?.status == 2
                              ? AppColors.red
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5),
                      child: Text(
                        serviceModel?.status == 0
                            ? "pending".tr()
                            : serviceModel?.status == 2
                                ? "refused".tr()
                                : "",
                        style: getRegularStyle(
                          fontSize: 14.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Flexible(
            child: Container(
              height: getHeightSize(context) * 0.17,
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
                          serviceModel?.subServiceType ?? "Service ",
                          style: getRegularStyle(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      serviceModel?.title ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(fontSize: 16.sp, fontHeight: 1.2),
                    ),
                    if (serviceModel?.price != null)
                      SizedBox(
                        // width: getWidthSize(context) * 0.6,
                        child: AutoSizeText(
                          '${serviceModel?.price.toString() ?? "0"}'
                          " \$",
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
                            serviceModel?.locationName ?? "",
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
