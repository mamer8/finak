
import 'package:finak/core/exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../cubit/location_cubit.dart';
import '../../cubit/location_state.dart';
import 'show_full_screen_map.dart';

class ShowPositionMap extends StatefulWidget {
  ShowPositionMap({super.key, this.lat, this.long});
  String? lat;
  String? long;
  @override
  State<ShowPositionMap> createState() => _ShowPositionMapState();
}

class _ShowPositionMapState extends State<ShowPositionMap> {
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
        return ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
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
                            builder: (context) => ShowFullScreenMap(
                              latitude:
                                  double.tryParse(widget.lat.toString()) ?? 0.0,
                              longitude:
                                  double.tryParse(widget.long.toString()) ??
                                      0.0,
                            ),
                          ),
                        );
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.tryParse(widget.lat.toString()) ?? 0.0,
                          double.tryParse(widget.long.toString()) ?? 0.0,
                        ),
                        zoom: 10,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        cubit.showMapControllerPositioned = controller;
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("selected_location"),
                          icon: cubit.markerIcon != null
                              ? BitmapDescriptor.bytes(cubit.markerIcon!)
                              : BitmapDescriptor.defaultMarker,
                          position: LatLng(
                              double.tryParse(widget.lat.toString()) ?? 0.0,
                              double.tryParse(widget.long.toString()) ?? 0.0),
                        ),
                      },
                    )

//              Stack(
//               children: [
//                 SizedBox(
//                     width: double.infinity,
//                     height: getHeightSize(context) * 0.3,
//                     child: GoogleMap(
//                       zoomGesturesEnabled: true,
//                       zoomControlsEnabled: true,
//                       mapType: MapType.normal,
//                       onTap: (argument) {
//                         print("sssssssssss");

//                       },
//                       initialCameraPosition: CameraPosition(
//                         target: LatLng(
//                          cubit.selectedLocation!.latitude ?? 0.0,
//                           cubit.selectedLocation!.longitude ?? 0.0,
//                         ),
//                         zoom: 10,
//                       ),
//                       onMapCreated: (GoogleMapController controller) {
//                         cubit.mapControllerPosition = controller;
//                       },
// markers: cubit.transportationMarkers,                    )),
//                 PositionedDirectional(
//                   bottom: 10.0,
//                   end: 10.0,
//                   child: Container(
//                     width: getWidthSize(context) * 0.7,
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     // alignment: Alignment.center,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         cubit.address,
//                         style: getMediumStyle(
//                           fontSize: 14.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
              ),
        );
      },
    );
  }
}
