import 'package:finak/core/exports.dart';
import 'package:finak/features/services/cubit/cubit.dart';
import 'package:finak/features/services/cubit/state.dart';
import 'package:finak/features/services/screens/services_screen.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class CustomFilterWidget extends StatelessWidget {
  const CustomFilterWidget({
    super.key,
    this.isHome = false,
  });
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFilterBottomSheet(context, isHome: isHome);
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

void showFilterBottomSheet(BuildContext context, {bool isHome = false}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      // showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return MyFiltersWidget(
          isHome: isHome,
        );
      });
}

class MyFiltersWidget extends StatefulWidget {
  const MyFiltersWidget({
    super.key,
    this.isHome = false,
  });
  final bool isHome;

  @override
  State<MyFiltersWidget> createState() => _MyFiltersWidgetState();
}

class _MyFiltersWidgetState extends State<MyFiltersWidget> {
  @override
  void initState() {
    if (context.read<ServicesCubit>().subServiceTypesModel.data == null &&
        context.read<ServicesCubit>().selectedServiceType != null) {
      context.read<ServicesCubit>().getSubServiceTypes(
          context.read<ServicesCubit>().selectedServiceType!.id.toString());
    }
    super.initState();
  }

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
                        min: 0,
                        max: 1000,
                        // divisions: 10,
                        activeColor: cubit.isPriceRangeEnabled
                            ? AppColors.primary
                            : Colors.grey[300],
                        inactiveColor: Colors.grey[300],
                        onChanged: (RangeValues newValues) {
                          cubit.changeRange(newValues);
                        },
                      ),
                      if (cubit.isPriceRangeEnabled)
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
                      if (state is GetServiceTypesLoadingState)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(
                            color: AppColors.primary,
                            backgroundColor: AppColors.white,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: (cubit.serviceTypesModel.data
                                  ?.map(
                                    (e) => CustomTypesWidget(
                                      title: e.name ?? '',
                                      isSelected:
                                          cubit.selectedServiceType?.id == e.id,
                                      onTap: () {
                                        cubit.changeSelectedServiceType(e,
                                            isGetServices: false,
                                            context: context);
                                      },
                                    ),
                                  )
                                  .toList()) ??
                              [],
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
                      if (state is GetSubServiceTypesLoadingState)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(
                            color: AppColors.primary,
                            backgroundColor: AppColors.white,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: (cubit.subServiceTypesModel.data
                                  ?.map(
                                    (e) => CustomTypesWidget(
                                      title: e.name ?? '',
                                      isSelected:
                                          cubit.selectedSubServiceType?.id ==
                                              e.id,
                                      onTap: () {
                                        cubit.onTapToSelectSubServiceType(
                                          e,
                                          isGetServices: false,
                                          context: context,
                                        );
                                      },
                                    ),
                                  )
                                  .toList()) ??
                              [],
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
                                isSelected: cubit.currentDistance == e,
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
                    // Navigator.pop(context);
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
                      if (widget.isHome) {
                        Navigator.pushNamed(context, Routes.servicesRoute,
                            arguments: ServicesScreenArgs(
                                selectedSubServiceType: cubit
                                    .selectedSubServiceType,
                                selected: cubit.selectedServiceType));
                      }

                      cubit.getServices(context);
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
