import 'package:easy_debounce/easy_debounce.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/network_image.dart';
import 'package:finak/core/widgets/no_data_widget.dart';
import 'package:finak/features/home/cubit/cubit.dart';
import 'package:finak/features/home/cubit/state.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/location/cubit/location_state.dart';
import 'package:finak/features/menu/screens/widgets/custom_menu_row.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:finak/features/profile/cubit/state.dart';
import 'package:finak/features/services/cubit/cubit.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';
import 'package:finak/features/services/screens/services_screen.dart';

import 'widgets/category_widget.dart';
import 'widgets/custom_notification_widget.dart';
import 'widgets/custom_search_text_field.dart';
import 'widgets/service_home_widget.dart';
import 'widgets/swiper_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().getHome();
    context.read<ProfileCubit>().getProfile();
    if (context.read<ServicesCubit>().serviceTypesModel.data == null) {
      context.read<ServicesCubit>().getServiceTypes();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
            var profileCubit = context.read<ProfileCubit>();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: Row(
                children: [
                  CustomNetworkImage(
                      image: profileCubit.loginModel.data?.image ?? '',
                      isUser: true,
                      width: 50.w,
                      height: 50.w,
                      borderRadius: 50.w),
                  10.w.horizontalSpace,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConst.isLogged
                              ? profileCubit.loginModel.data?.name ?? ''
                              : 'guest'.tr(),
                          style: getBoldStyle(fontSize: 18.sp),
                        ),
                        5.h.verticalSpace,
                        Row(
                          children: [
                            Image.asset(
                              ImageAssets.locationIcon,
                              width: 15.w,
                            ),
                            5.w.horizontalSpace,
                            Flexible(
                              child: BlocBuilder<LocationCubit, LocationState>(
                                  builder: (context, state) {
                                var locationCubit =
                                    context.read<LocationCubit>();
                                return AutoSizeText(
                                  locationCubit.address,
                                  maxLines: 1,
                                  style: getRegularStyle(fontSize: 14.sp),
                                );
                              }),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  10.w.horizontalSpace,
                  CustomNotificationWidget(
                      count:
                          profileCubit.loginModel.data?.notificationCount ?? 0),
                ],
              ),
            );
          }),
          Expanded(
              child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              cubit.getHome();
            },
            child: state is GetHomeErrorState
                ? CustomNoDataWidget(
                    message: 'error_happened'.tr(),
                    onTap: () {
                      cubit.getHome();
                    },
                  )
                : state is GetHomeLoadingState || cubit.homeModel.data == null
                    ? const Center(child: CustomLoadingIndicator())
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            CustomSearchTextField(
                              isHome: true,
                              controller: context
                                  .read<ServicesCubit>()
                                  .searchController,
                              onChanged: (value) {
                                EasyDebounce.debounce('saerch-offers-debouncer',
                                    const Duration(seconds: 1), () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.pushNamed(
                                      context, Routes.servicesRoute,
                                      arguments: ServicesScreenArgs());
                                });
                              },
                            ),
                            20.h.verticalSpace,
                            CustomSwiper(
                              images: cubit.homeModel.data?.slider
                                      ?.map((e) => e.image ?? "")
                                      .toList() ??
                                  [],
                            ),
                            20.h.verticalSpace,
                            // categories
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: SizedBox(
                                height: getHeightSize(context) * 0.05,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cubit.homeModel.data?.serviceTypes
                                          ?.length ??
                                      0,
                                  separatorBuilder: (context, index) {
                                    return 10.w.horizontalSpace;
                                  },
                                  itemBuilder: (context, index) {
                                    return CustomCategoryContainer(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, Routes.servicesRoute,
                                            arguments: ServicesScreenArgs(
                                                selected: cubit.homeModel.data
                                                    ?.serviceTypes?[index]));
                                      },
                                      model: cubit.homeModel.data
                                              ?.serviceTypes?[index] ??
                                          ServiceTypeModel(),
                                    );
                                  },
                                ),
                              ),
                            ),
                            20.h.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "recommended".tr(),
                                    style: getBoldStyle(fontSize: 20.sp),
                                  ),
                                  10.w.horizontalSpace,
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.servicesRoute,
                                          arguments: ServicesScreenArgs());
                                    },
                                    child: Text(
                                      "all".tr(),
                                      style: getRegularStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            20.h.verticalSpace,
                            // services
                            SizedBox(
                              height: getHeightSize(context) * 0.31,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    cubit.homeModel.data?.recommended?.length ??
                                        0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 12.w,
                                        end: index + 1 ==
                                                cubit.homeModel.data
                                                    ?.recommended?.length
                                            ? 12.w
                                            : 0),
                                    child: CustomServiceHomeWidget(
                                      serviceModel: cubit
                                          .homeModel.data?.recommended?[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                            20.h.verticalSpace,
                            kToolbarHeight.verticalSpace,
                          ],
                        )),
          )),
        ],
      );
    });
  }
}
