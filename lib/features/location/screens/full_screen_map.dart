// ignore_for_file: deprecated_member_use

import 'package:finak/core/exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

class FullScreenMap extends StatelessWidget {
  const FullScreenMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LocationCubit cubit = context.read<LocationCubit>();
    return Scaffold(
      appBar: customAppBar(context, title: "select_location".tr()),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return cubit.selectedLocation == null
              ? const Center(child: CustomLoadingIndicator())
              : GoogleMap(
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
                    cubit.mapControllerPositioned = controller;
                  },
                  markers: cubit.positionMarkers,
                  onTap: (LatLng latLng) => cubit.updateSelectedCameraPosition(
                    latLng,
                    context,
                  ),
                );
        },
      ),
    );
  }
}
