import 'package:finak/core/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/swiper_widget.dart';

class ServiceDetailsArgs {
  final bool isOffers;
  ServiceDetailsArgs({this.isOffers = false});
}

class ServicesDetailsScreen extends StatelessWidget {
  const ServicesDetailsScreen({
    super.key,
    required this.args,
  });
  final ServiceDetailsArgs args;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(builder: (context, state) {
      return Scaffold(
        body: Column(
          children: [
            const CustomDetailsSwiper(
              title: " Lorem ipsum dolor aliqua.",
              images: [
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                // "https://www.example.com/image.jpg",
                // "https://www.example.com/image.jpg",
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          "Lorem ipsum dolor sit  ",
                          style: getBoldStyle(fontSize: 18.sp),
                        ),
                      ),
                      10.w.horizontalSpace,
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 18.r,
                        child: Icon(
                          Icons.favorite_rounded,
                          color: AppColors.white,
                          // size: 20.w,
                        ),
                      ),
                    ]),
                    10.h.verticalSpace,
                    Text(
                      "5000 \$",
                      style: getMediumStyle(
                          fontSize: 18.sp, color: AppColors.primary),
                    ),
                    10.h.verticalSpace,
                    Text(
                      "location".tr(),
                      style: getBoldStyle(fontSize: 18.sp),
                    ),
                    10.h.verticalSpace,
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
                    ),
                    10.h.verticalSpace,
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. Nulla nec purus feugiat, molestie ipsum et, eleifend dolor. ",
                      style: getRegularStyle(fontSize: 14.sp),
                    ),
                    20.h.verticalSpace,
                    if (args.isOffers) ...[
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "status".tr(),
                            style: getBoldStyle(color: AppColors.primary)),
                        TextSpan(
                            text: ": ",
                            style: getBoldStyle(
                                fontSize: 14.sp, color: AppColors.primary)),
                        TextSpan(
                            text: "open".tr(),
                            style: getRegularStyle(
                                fontSize: 14.sp,
                                color: AppColors.secondPrimary))
                      ])),
                      30.h.verticalSpace,
                      CustomButton(
                        title: "close".tr(),
                        onPressed: () {},
                      ),
                    ] else ...[
                      Divider(
                        color: AppColors.gray,
                      ),
                      20.h.verticalSpace,
                      Row(
                        children: [
                          CustomNetworkImage(
                              image: "https://www.example.com/image.jpg",
                              isUser: true,
                              width: 70.w,
                              height: 70.w,
                              borderRadius: 50.w),
                          10.w.horizontalSpace,
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John DoeDoe',
                                  style: getBoldStyle(fontSize: 16.sp),
                                ),
                                5.h.verticalSpace,
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.time,
                                      color: AppColors.primaryGrey,
                                      size: 20.w,
                                    ),
                                    5.w.horizontalSpace,
                                    Text(
                                      'posted 1 day ago',
                                      style: getRegularStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.primaryGrey,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          10.w.horizontalSpace,
                          Row(children: [
                            SvgPicture.asset(
                              ImageAssets.callIcon,
                              width: 40.w,
                            ),
                            10.w.horizontalSpace,
                            SvgPicture.asset(
                              ImageAssets.messageIcon,
                              width: 40.w,
                            ),
                          ]),
                        ],
                      ),
                      20.h.verticalSpace,
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "email".tr(),
                            style: getBoldStyle(color: AppColors.primary)),
                        TextSpan(
                            text: ": ",
                            style: getBoldStyle(
                                fontSize: 14.sp, color: AppColors.primary)),
                        TextSpan(
                            text: "email@example",
                            style: getRegularStyle(
                                fontSize: 14.sp, color: AppColors.primary))
                      ])),
                      10.h.verticalSpace,
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "status".tr(),
                            style: getBoldStyle(color: AppColors.primary)),
                        TextSpan(
                            text: ": ",
                            style: getBoldStyle(
                                fontSize: 14.sp, color: AppColors.primary)),
                        TextSpan(
                            text: "open".tr(),
                            style: getRegularStyle(
                                fontSize: 14.sp,
                                color: AppColors.secondPrimary))
                      ])),
                    ],
                    kToolbarHeight.verticalSpace
                  ],
                ),
              ),
            )),
          ],
        ),
      );
    });
  }
}
