// ignore_for_file: deprecated_member_use

import 'package:finak/core/exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import 'full_screen_map.dart';

class PositionMap extends StatefulWidget {
  const PositionMap({
    super.key,
  });

  @override
  State<PositionMap> createState() => _PositionMapState();
}

class _PositionMapState extends State<PositionMap> {
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
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text("${"location".tr()} *",
                  style: getBoldStyle(fontSize: 18.sp)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.r),
                ),
                child: Container(
                    width: double.infinity,
                    height: getHeightSize(context) * 0.2,
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                    ),
                    child: cubit.selectedLocation == null
                        ? const Center(child: CustomLoadingIndicator())
                        : GoogleMap(
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            mapType: MapType.normal,
                            onTap: (argument) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenMap(),
                                ),
                              );
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                cubit.selectedLocation!.latitude ?? 0.0,
                                cubit.selectedLocation!.longitude ?? 0.0,
                              ),
                              zoom: 12,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              cubit.positionMapController = controller;
                            },
                            markers: cubit.positionMarkers,
                          )),
              ),
            ),
          ],
        );
      },
    );
  }
}
