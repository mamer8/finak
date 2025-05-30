import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/no_data_widget.dart';
import 'package:finak/features/chat/cubit/cubit.dart';
import 'package:finak/features/chat/screens/chat_screen.dart';
import 'package:finak/features/favorite/screens/widgets/fav_button.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/swiper_widget.dart';

class ServiceDetailsArgs {
  final bool isOffers;
  final bool isFavoriteScreen;
  final ServiceModel? serviceModel;
  final bool isFromNotification;

  ServiceDetailsArgs(
      {this.isOffers = false,
      this.isFavoriteScreen = false,
      this.isFromNotification = false,
      this.serviceModel});
}

class ServicesDetailsScreen extends StatefulWidget {
  const ServicesDetailsScreen({
    super.key,
    required this.args,
  });
  final ServiceDetailsArgs args;

  @override
  State<ServicesDetailsScreen> createState() => _ServicesDetailsScreenState();
}

class _ServicesDetailsScreenState extends State<ServicesDetailsScreen> {
  @override
  void initState() {
    context.read<ServicesCubit>().getServiceDetails(
          offerId: widget.args.serviceModel?.id.toString() ?? "",
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ServicesCubit>();
    return BlocBuilder<ServicesCubit, ServicesState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          if (widget.args.isFromNotification) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.mainRoute, (route) => false);
          } else {
            Navigator.pop(context);
          }
          return false;
        },
        child: Scaffold(
          body: Center(
            child: state is GetServiceDetailsErrorState
                ? CustomNoDataWidget(
                    message: 'error_happened'.tr(),
                    onTap: () {
                      cubit.getServiceDetails(
                        offerId: widget.args.serviceModel?.id.toString() ?? "",
                      );
                    },
                  )
                : state is GetServiceDetailsLoadingState ||
                        cubit.getServiceDetailsModel.data == null
                    ? const Center(child: CustomLoadingIndicator())
                    : Column(
                        children: [
                          CustomDetailsSwiper(
                              onTap: () {
                                if (widget.args.isFromNotification) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      Routes.mainRoute, (route) => false);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              title: cubit.getServiceDetailsModel.data?.title ??
                                  "",
                              images: cubit.getServiceDetailsModel.data?.media
                                      ?.map((e) => e.image ?? "")
                                      .toList() ??
                                  []),
                          Expanded(
                              child: RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async {
                              cubit.getServiceDetails(
                                offerId:
                                    widget.args.serviceModel?.id.toString() ??
                                        "",
                              );
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                          cubit.getServiceDetailsModel.data
                                                  ?.title ??
                                              "",
                                          style: getBoldStyle(fontSize: 18.sp),
                                        ),
                                      ),
                                      10.w.horizontalSpace,
                                      CustomFavButton(
                                        isDetails: true,
                                        isFavoriteScreen:
                                            widget.args.isFavoriteScreen,
                                        isFav: cubit.getServiceDetailsModel.data
                                                ?.isFav ??
                                            false,
                                        serviceId: cubit.getServiceDetailsModel
                                                .data?.id ??
                                            0,
                                      ),
                                    ]),
                                    10.h.verticalSpace,
                                    if (cubit.getServiceDetailsModel.data
                                            ?.price !=
                                        null)
                                      Text(
                                        '${cubit.getServiceDetailsModel.data?.price.toString() ?? "0"}'
                                        " \$",
                                        style: getMediumStyle(
                                            fontSize: 18.sp,
                                            color: AppColors.primary),
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
                                            cubit.getServiceDetailsModel.data
                                                    ?.locationName ??
                                                "",
                                            maxLines: 2,
                                            minFontSize: 10.sp,
                                            style: getRegularStyle(
                                                fontSize: 14.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                    10.h.verticalSpace,
                                    Text(
                                      cubit.getServiceDetailsModel.data?.body ??
                                          "",
                                      style: getRegularStyle(fontSize: 14.sp),
                                    ),
                                    20.h.verticalSpace,
                                    if (cubit.getServiceDetailsModel.data
                                            ?.isMine ??
                                        false) ...[
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: "status".tr(),
                                            style: getBoldStyle(
                                                color: AppColors.primary)),
                                        TextSpan(
                                            text: ": ",
                                            style: getBoldStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.primary)),
                                        TextSpan(
                                            text: cubit.getServiceDetailsModel
                                                        .data?.isOpen
                                                        .toString() ==
                                                    "0"
                                                ? "closed".tr()
                                                : "opened".tr(),
                                            style: getRegularStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.secondPrimary))
                                      ])),
                                      30.h.verticalSpace,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomButton(
                                              title:
                                                  cubit.getServiceDetailsModel
                                                              .data?.isOpen
                                                              .toString() ==
                                                          "1"
                                                      ? "close".tr()
                                                      : "open".tr(),
                                              onPressed: () {
                                                cubit.closeOrOpenOffer(context,
                                                    isClose: cubit
                                                            .getServiceDetailsModel
                                                            .data
                                                            ?.isOpen
                                                            .toString() ==
                                                        "1",
                                                    offerId: widget.args
                                                            .serviceModel?.id
                                                            .toString() ??
                                                        "");
                                              },
                                            ),
                                          ),
                                          // 10.w.horizontalSpace,
                                          Expanded(
                                            child: CustomButton(
                                              title: "edit".tr(),
                                              fontColor: AppColors.primary,
                                              backgroundColor: AppColors.white,
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    Routes.updateOfferRoute,
                                                    arguments: cubit
                                                        .getServiceDetailsModel
                                                        .data);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ] else ...[
                                      Divider(
                                        color: AppColors.gray,
                                      ),
                                      20.h.verticalSpace,
                                      Row(
                                        children: [
                                          CustomNetworkImage(
                                              image: cubit
                                                      .getServiceDetailsModel
                                                      .data
                                                      ?.provider
                                                      ?.image ??
                                                  "",
                                              isUser: true,
                                              width: 70.w,
                                              height: 70.w,
                                              borderRadius: 50.w),
                                          10.w.horizontalSpace,
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cubit
                                                          .getServiceDetailsModel
                                                          .data
                                                          ?.provider
                                                          ?.name ??
                                                      "",
                                                  style: getBoldStyle(
                                                      fontSize: 16.sp),
                                                ),
                                                5.h.verticalSpace,
                                                Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.time,
                                                      color:
                                                          AppColors.primaryGrey,
                                                      size: 20.w,
                                                    ),
                                                    5.w.horizontalSpace,
                                                    Text(
                                                      cubit
                                                              .getServiceDetailsModel
                                                              .data
                                                              ?.provider
                                                              ?.postedAt ??
                                                          "",
                                                      style: getRegularStyle(
                                                        fontSize: 14.sp,
                                                        color: AppColors
                                                            .primaryGrey,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          10.w.horizontalSpace,
                                          Row(children: [
                                            if (cubit.getServiceDetailsModel
                                                    .data?.isPhoneHide
                                                    .toString() ==
                                                "0")
                                              InkWell(
                                                onTap: () async =>
                                                    await cubit.callPhone(cubit
                                                            .getServiceDetailsModel
                                                            .data
                                                            ?.provider
                                                            ?.phone ??
                                                        ""),
                                                child: SvgPicture.asset(
                                                  ImageAssets.callIcon,
                                                  width: 40.w,
                                                ),
                                              ),
                                            10.w.horizontalSpace,
                                            InkWell(
                                              onTap: () async {
                                                if (cubit
                                                        .getServiceDetailsModel
                                                        .data
                                                        ?.provider
                                                        ?.roomId !=
                                                    null) {
                                                  Navigator.pushNamed(
                                                      context, Routes.chatRoute,
                                                      arguments:
                                                          ChatScreenArguments(
                                                        cubit
                                                                .getServiceDetailsModel
                                                                .data
                                                                ?.provider
                                                                ?.roomId ??
                                                            0,
                                                        cubit
                                                                .getServiceDetailsModel
                                                                .data
                                                                ?.provider
                                                                ?.name ??
                                                            "",
                                                      ));
                                                } else {
                                                  await context
                                                      .read<ChatCubit>()
                                                      .createRoom(context,
                                                          recieverName: cubit
                                                                  .getServiceDetailsModel
                                                                  .data
                                                                  ?.provider
                                                                  ?.name ??
                                                              "",
                                                          recieverId: cubit
                                                                  .getServiceDetailsModel
                                                                  .data
                                                                  ?.provider
                                                                  ?.id
                                                                  .toString() ??
                                                              "");
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                ImageAssets.messageIcon,
                                                width: 40.w,
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                      20.h.verticalSpace,
                                      if (cubit.getServiceDetailsModel.data
                                              ?.provider?.email !=
                                          null)
                                        RichText(
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: "email".tr(),
                                              style: getBoldStyle(
                                                  color: AppColors.primary)),
                                          TextSpan(
                                              text: ": ",
                                              style: getBoldStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.primary)),
                                          TextSpan(
                                              text: cubit.getServiceDetailsModel
                                                      .data?.provider?.email ??
                                                  "",
                                              style: getRegularStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.primary))
                                        ])),
                                      10.h.verticalSpace,
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: "status".tr(),
                                            style: getBoldStyle(
                                                color: AppColors.primary)),
                                        TextSpan(
                                            text: ": ",
                                            style: getBoldStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.primary)),
                                        TextSpan(
                                            text: cubit.getServiceDetailsModel
                                                        .data?.isOpen
                                                        .toString() ==
                                                    "0"
                                                ? "close".tr()
                                                : "open".tr(),
                                            style: getRegularStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.secondPrimary))
                                      ])),
                                    ],
                                    kToolbarHeight.verticalSpace
                                  ],
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
          ),
        ),
      );
    });
  }
}
