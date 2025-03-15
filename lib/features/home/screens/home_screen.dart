import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/network_image.dart';
import 'package:finak/features/home/cubit/cubit.dart';
import 'package:finak/features/home/cubit/state.dart';
import 'package:finak/features/menu/screens/widgets/custom_menu_row.dart';

import 'widgets/category_widget.dart';
import 'widgets/custom_notification_widget.dart';
import 'widgets/custom_search_text_field.dart';
import 'widgets/service_home_widget.dart';
import 'widgets/swiper_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
            child: Row(
              children: [
                CustomNetworkImage(
                    image: "https://www.example.com/image.jpg",
                    width: 50.w,
                    height: 50.w,
                    borderRadius: 50.w),
                10.w.horizontalSpace,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John DoeDoe',
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
                          Text(
                            'New York, USA',
                            style: getRegularStyle(fontSize: 14.sp),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                10.w.horizontalSpace,
                const CustomNotificationWidget(count: "12"),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              const CustomSearchTextField(),
              20.h.verticalSpace,
              const CustomSwiper(
                images: [
                  "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=414x232",
                  "https://static-new.lhw.com/HotelImages/Final/LW0430/lw0430_177729896_720x450.jpg",
                  // "https://www.example.com/image.jpg",
                ],
              ),
              20.h.verticalSpace,
              // categories
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SizedBox(
                  height: getHeightSize(context) * 0.05,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (context, index) {
                      return 10.w.horizontalSpace;
                    },
                    itemBuilder: (context, index) {
                      return CustomCategoryContainer(
                        isSelected: true,
                      );
                    },
                  ),
                ),
              ),
              20.h.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "recommended".tr(),
                      style: getBoldStyle(fontSize: 20.sp),
                    ),
                    10.w.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.servicesRoute);
                      },
                      child: Text(
                        "all".tr(),
                        style: getRegularStyle(
                            fontSize: 16.sp, color: AppColors.primary),
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
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 12.w, end: index == 4 ? 12.w : 0),
                      child: CustomServiceHomeWidget(),
                    );
                  },
                ),
              ),
            ],
          ))),
        ],
      );
    });
  }
}
