// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:finak/core/exports.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'dart:ui' as ui;
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial()) {
    getmarker();
  }
  StreamSubscription<Position>? positionStream;

  Set<Marker> positionMarkers = <Marker>{};
  Uint8List? markerIcon;
  loc.LocationData? currentLocation;
  bool isFirstTime = true;
  loc.LocationData? selectedLocation;
  String loggedUserId = "";

 

  Future<void> checkAndRequestLocationPermission(BuildContext context) async {
    getmarker();
    perm.PermissionStatus permissionStatus =
        await perm.Permission.location.status;
    if (permissionStatus.isDenied) {
      perm.PermissionStatus newPermissionStatus =
          await perm.Permission.location.request();
      if (newPermissionStatus.isGranted) {
        await enableLocationServices(context);
      }
    } else if (permissionStatus.isGranted) {
      await enableLocationServices(context);
    } else if (permissionStatus.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("location_required".tr()),
          content: Text("location_describtion".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr()),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await perm.openAppSettings();
              },
              child: Text("open_settings".tr()),
            ),
          ],
        ),
      );
    }
  }

  Future<void> enableLocationServices(BuildContext context) async {
    loc.Location location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionStatus =
        await loc.Location().hasPermission();
    if (permissionStatus == loc.PermissionStatus.granted) {
      getCurrentLocation(context);
    }
  }

  /// ✅ **الحصول على الموقع الحالي إذا لم يتم تحديده يدويًا**
  Future<void> getCurrentLocation(BuildContext context) async {
    loc.Location location = loc.Location();
    location.getLocation().then((location) async {
      currentLocation = location;
      if (isFirstTime && selectedLocation == null) {
        selectedLocation = location;
        // context.read<ViolationReportCubit>().latController.text=location.latitude.toString();
        // context.read<ViolationReportCubit>().longController.text=location.longitude.toString();
        // context.read<ViolationReportCubit>().mapUrl.text='https://www.google.com/maps/dir/?api=1&destination=${location.latitude ?? 0},${location.longitude ?? 0}';
      }
      isFirstTime = false;
      getAddressFromLatLng(location.latitude ?? 0.0, location.longitude ?? 0.0);
      setTransportationMarkers();
      emit(GetCurrentLocationState());
     
    });

    location.onLocationChanged.listen((newLocationData) async {
   
     
      if (currentLocation != null) {
        double distance = Geolocator.distanceBetween(
          currentLocation!.latitude ?? 0.0,
          currentLocation!.longitude ?? 0.0,
          newLocationData.latitude ?? 0.0,
          newLocationData.longitude ?? 0.0,
        );

        if (distance > 8) {
          currentLocation = newLocationData;

          emit(GetCurrentLocationState());
        }
      }
    });
  }

  void setTransportationMarkers() {
    positionMarkers = {
      Marker(
        markerId: const MarkerId('selectedLocation'),
        icon: markerIcon != null
            ? BitmapDescriptor.bytes(markerIcon!)
            : BitmapDescriptor.defaultMarker,
        position: LatLng(
          selectedLocation?.latitude ?? 0.0,
          selectedLocation?.longitude ?? 0.0,
        ),
      ),
    };
    emit(SetTransportationMarkersState());
  }

  Future<void> getmarker() async {
    markerIcon = await getBytesFromAsset(ImageAssets.pin, 50);
emit(SetTransportationMarkersState());  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
 GoogleMapController? showMapControllerPositioned;
  GoogleMapController? mapControllerPositioned;
  GoogleMapController? positionMapControllerPositioned;
 

  Future<void> updateSelectedCameraPosition(LatLng latLng, BuildContext context,
     ) async {
    if (mapControllerPositioned != null && positionMapControllerPositioned != null) {
      mapControllerPositioned!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latLng.latitude, latLng.longitude),
        ),
      );
      positionMapControllerPositioned!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latLng.latitude, latLng.longitude),
        ),
      );

      setSelectedLocation(latLng, context, );
    }
  }
void setSelectedLocation(LatLng latLng, BuildContext? context,
    ) {
    selectedLocation = loc.LocationData.fromMap({
      "latitude": latLng.latitude,
      "longitude": latLng.longitude,
    });
    getAddressFromLatLng(latLng.latitude, latLng.longitude);
    setTransportationMarkers();
  
    emit(SetSelectedLocationState());
  }
  void disposeController() {
    mapControllerPositioned?.dispose();
    emit(DisposeMapState());
  }

  String country = " country ";
  String city = " city ";
  String address = " address ";
  String address2 = " address ";

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    address = "Loading...";
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        country = place.country ?? "";
        city = place.locality ?? "";
        address2 =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}, ${place.administrativeArea}, ${place.name}, ${place.subLocality}, ${place.subThoroughfare}";
        address = "${place.locality}, ${place.administrativeArea}";
        emit(GetCurrentLocationAddressState());
      } else {
        emit(ErrorCurrentLocationAddressState());
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      emit(ErrorCurrentLocationAddressState());
    }
  }

  bool isLocationNull(BuildContext context) {
    if (currentLocation == null) {
      checkAndRequestLocationPermission(context);
      return true;
    }
    return false;
  }

  // void openGoogleMapsRoute(double destinationLat, double destinationLng) async {
  //   String url =
  //       'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng';

  //   if (currentLocation != null) {
  //     url =
  //         'https://www.google.com/maps/dir/?api=1&origin=${currentLocation!.latitude ?? 0},${currentLocation!.longitude ?? 0}&destination=$destinationLat,$destinationLng';
  //   }
  //   try {
  //     launchUrl(Uri.parse(url));
  //   } catch (e) {
  //     debugPrint("Error opening Google Maps: $e");
  //   }
  // }
}
