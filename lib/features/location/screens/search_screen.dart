// ignore_for_file: deprecated_member_use

import 'package:easy_debounce/easy_debounce.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/features/home/screens/widgets/custom_search_text_field.dart';
import 'package:finak/features/services/screens/widgets/service_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

class SearcMapScreen extends StatefulWidget {
  const SearcMapScreen({
    super.key,
  });

  @override
  State<SearcMapScreen> createState() => _SearcMapScreenState();
}

class _SearcMapScreenState extends State<SearcMapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<LocationCubit>()
            .checkAndRequestLocationPermission(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationCubit cubit = context.read<LocationCubit>();
    return Scaffold(
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return cubit.selectedLocation == null
              ? const Center(child: CustomLoadingIndicator())
              : SizedBox(
                  height: getHeightSize(context),
                  width: getWidthSize(context),
                  child: Stack(
                    children: [
                      GoogleMap(
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            cubit.selectedLocation?.latitude ?? 0.0,
                            cubit.selectedLocation?.longitude ?? 0.0,
                          ),
                          zoom: 12,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          cubit.searchMapController = controller;
                        },
                        markers: cubit.servicesMarkers,
                        onTap: (LatLng latLng) => cubit.updateSelectedCamera(
                          latLng,
                          context,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Column(
                          children: [
                            10.h.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              child: Row(children: [
                                Text("search_range".tr(),
                                    style: getBoldStyle(
                                      fontSize: 18.sp,
                                    )),
                                const Spacer(),
                                Text(
                                    "${cubit.currentValue.toInt()} ${"km".tr()}",
                                    style: getBoldStyle(
                                      fontSize: 18.sp,
                                    )),
                              ]),
                            ),
                            Slider(
                              value: cubit.currentValue,
                              max: 400,
                              onChangeEnd: (v) {
                                print("Selected value: ${cubit.currentValue}");
                                cubit.getServices(context);
                              },
                              activeColor: AppColors.primary,
                              min: 0.1,
                              inactiveColor: Colors.grey[300],
                              onChanged: (double newValue) {
                                cubit.changeValue(newValue);
                                // EasyDebounce.debounce('search-debouncer',
                                //     const Duration(seconds: 1), () async {
                                //   // return await cubit.getHomeFilterData(
                                //   //   context: context)();
                                // });
                              },
                            ),
                            // 5.h.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                              ),
                              child: CustomSearchTextField(
                                isFiler: false,
                                suffixIcon: state is GetServicesLoadingState
                                    ? Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: SizedBox(
                                          height: 10.h,
                                          child: CircularProgressIndicator(
                                            
                                              color: AppColors.primary),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () => cubit.getServices(context),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                "search".tr(),
                                                style: getRegularStyle(
                                                    fontSize: 16.sp,
                                                    color: AppColors.primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                controller: cubit.searchController,
                                onChanged: (value) {
                                  EasyDebounce.debounce('search-debouncer',
                                      const Duration(seconds: 1), () async {
                                    cubit.getServices(context);
                                  });
                                },
                              ),
                            ),
                            const Spacer(),
                            if (cubit.selectedService != null)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                ),
                                child: CustomServiceWidget(
                                  serviceModel: cubit.selectedService,
                                ),
                              ),
                            20.h.verticalSpace,
                            kToolbarHeight.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
