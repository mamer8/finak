// ignore_for_file: deprecated_member_use

import 'package:finak/core/exports.dart';
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
                    cubit.searchMapController = controller;
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
