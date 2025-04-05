import 'package:finak/core/exports.dart';
import 'package:finak/features/favorite/screens/widgets/fav_button.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/screens/services_details_screen.dart';

class CustomServiceHomeWidget extends StatelessWidget {
  const CustomServiceHomeWidget({
    super.key,
    this.serviceModel,
  });
  final ServiceModel? serviceModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.servicesDetailsRoute,
            arguments: ServiceDetailsArgs(
              serviceModel: serviceModel,
              // isOffers: isOffers,
            ));
      },
      child: Column(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  CustomNetworkImage(
                    image: serviceModel?.logo ?? '',
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
                          serviceModel?.subServiceType ?? '',
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
                    child: CustomFavButton(
                      isFav: serviceModel?.isFav ?? false,
                      serviceId: serviceModel?.id ?? 0,
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
                        serviceModel?.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(fontSize: 16.sp, fontHeight: 1.2),
                      ),
                      if (serviceModel?.price != null)
                        SizedBox(
                          width: getWidthSize(context) * 0.6,
                          child: AutoSizeText(
                            '${serviceModel?.price.toString() ?? "0"}'
                            " \$",
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
                              serviceModel?.locationName ?? "",
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
