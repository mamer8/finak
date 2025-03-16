import 'package:finak/core/exports.dart';
import 'package:finak/features/services/cubit/cubit.dart';
import 'package:finak/features/services/cubit/state.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class CustomFilterWidget extends StatelessWidget {
  const CustomFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFilterBottomSheet(context, 'termsAndConditions'.tr());
      },
      child: Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              ImageAssets.filterIcon,
            ),
          )),
    );
  }
}

void showFilterBottomSheet(BuildContext context, String terms) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      // showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return MyFiltersWidget();
      });
}

class MyFiltersWidget extends StatelessWidget {
  const MyFiltersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(builder: (context, state) {
      ServicesCubit cubit = context.read<ServicesCubit>();
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: getHeightSize(context) * 0.9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('price_range'.tr(),
                          style: getBoldStyle(
                            fontSize: 18.sp,
                          )),
                      10.h.verticalSpace,
                      RangeSlider(
                        values: cubit.currentRange,
                        min: 50000,
                        max: 300000,
                        // divisions: 10,
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.grey[300],
                        onChanged: (RangeValues newValues) {
                          cubit.changeRange(newValues);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPriceBox("Min", cubit.currentRange.start),
                          const SizedBox(width: 10),
                          const Text("-",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          _buildPriceBox("Max", cubit.currentRange.end),
                        ],
                      ),
                      20.h.verticalSpace,
                      Divider(
                        color: AppColors.gray,
                      ),
                      20.h.verticalSpace,
                      Text('service_type'.tr(),
                          style: getBoldStyle(
                            fontSize: 18.sp,
                          )),
                      10.h.verticalSpace,
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: cubit.serviceTypes
                            .map(
                              (e) => CustomTypesWidget(
                                title: e,
                                isSelected:
                                    cubit.currentServiceType.contains(e),
                                onTap: () {
                                  cubit.changeServiceType(e);
                                },
                              ),
                            )
                            .toList(),
                      ),
                      20.h.verticalSpace,
                      Divider(
                        color: AppColors.gray,
                      ),
                      20.h.verticalSpace,
                      Text('category'.tr(),
                          style: getBoldStyle(
                            fontSize: 18.sp,
                          )),
                      10.h.verticalSpace,
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: cubit.categories
                            .map(
                              (e) => CustomTypesWidget(
                                title: e,
                                isSelected: cubit.currentCategory.contains(e),
                                onTap: () {
                                  cubit.changeCategory(e);
                                },
                              ),
                            )
                            .toList(),
                      ),
                      20.h.verticalSpace,
                      Divider(
                        color: AppColors.gray,
                      ),
                      20.h.verticalSpace,
                      Text('distance'.tr(),
                          style: getBoldStyle(
                            fontSize: 18.sp,
                          )),
                      10.h.verticalSpace,
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: cubit.distances
                            .map(
                              (e) => CustomTypesWidget(
                                title: e,
                                isSelected: cubit.currentDistance.contains(e),
                                onTap: () {
                                  cubit.changeDistance(e);
                                },
                              ),
                            )
                            .toList(),
                      ),
                      80.h.verticalSpace,
                    ],
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: () {
                    cubit.clearFilters();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'clear'.tr(),
                    style: getBoldStyle(
                      color: AppColors.red,
                    ),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () {
                      // cubit.filterServices();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text('apply'.tr(),
                          style: getBoldStyle(
                            color: AppColors.white,
                          )),
                    ))
              ]),
              10.h.verticalSpace
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPriceBox(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label,
              style: getRegularStyle(
                fontSize: 16.sp,
              )),
          Text(
            '${value.toStringAsFixed(2)} \$',
            style: getBoldStyle(),
          ),
        ],
      ),
    );
  }
}

class CustomTypesWidget extends StatelessWidget {
  const CustomTypesWidget({
    super.key,
    this.onTap,
    this.isSelected = false,
    required this.title,
  });

  final void Function()? onTap;
  final bool isSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.white,
              border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.secondGrey),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              title,
              style: getRegularStyle(
                fontSize: 16.sp,
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            )));
  }
}
