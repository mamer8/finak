
import 'package:finak/core/exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../cubit/location_cubit.dart';
import '../../cubit/location_state.dart';

class ShowFullScreenMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const ShowFullScreenMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<ShowFullScreenMap> createState() => _ShowFullScreenMapState();
}

class _ShowFullScreenMapState extends State<ShowFullScreenMap> {

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().setSelectedLocation(
      LatLng(widget.latitude, widget.longitude),context
    );
  }

  @override
  Widget build(BuildContext context) {
    LocationCubit cubit = context.read<LocationCubit>();

    return Scaffold(
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return Scaffold(
appBar: customAppBar(
              context,
              title: "".tr(),

              ) ,
            body: GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 12,
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
                  position: LatLng(widget.latitude, widget.longitude),
                ),
              },
              onTap: (LatLng latLng) {
                setState(() {
                  cubit.setSelectedLocation(latLng, context);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
