// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:finak/core/exports.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;

import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial()) {
    _loadMarkerIcon();
  }

  StreamSubscription<Position>? _positionStream;
  Set<Marker> positionMarkers = <Marker>{};
  Uint8List? markerIcon;
  loc.LocationData? currentLocation;
  bool isFirstTime = true;
  loc.LocationData? selectedLocation;

  GoogleMapController? searchMapController;
  GoogleMapController? mapController;
  GoogleMapController? positionMapController;

  String country = "country";
  String city = "city";
  String address = "address";
  String address2 = "address2";

  Future<void> checkAndRequestLocationPermission(BuildContext context) async {
    final permissionStatus = await perm.Permission.location.status;

    if (permissionStatus.isDenied) {
      final newPermissionStatus = await perm.Permission.location.request();
      if (newPermissionStatus.isGranted) {
        await _enableLocationServices(context);
      }
    } else if (permissionStatus.isGranted) {
      await _enableLocationServices(context);
    } else if (permissionStatus.isPermanentlyDenied) {
      _showLocationPermissionDialog(context);
    }
  }

  Future<void> _enableLocationServices(BuildContext context) async {
    final location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    final permissionStatus = await location.hasPermission();
    if (permissionStatus == loc.PermissionStatus.granted) {
      await _getCurrentLocation(context);
    }
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    final location = loc.Location();
    location.getLocation().then((location) async {
      currentLocation = location;
      if (isFirstTime && selectedLocation == null) {
        selectedLocation = location;
      }
      isFirstTime = false;

      await _getAddressFromLatLng(
          location.latitude ?? 0.0, location.longitude ?? 0.0);
      _setTransportationMarkers();
      emit(GetCurrentLocationState());
    });

    location.onLocationChanged.listen((newLocationData) async {
      if (currentLocation != null) {
        final distance = Geolocator.distanceBetween(
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

  void _setTransportationMarkers() {
    positionMarkers = {
      Marker(
        markerId: const MarkerId('selectedLocation'),
        icon: markerIcon != null
            ? BitmapDescriptor.fromBytes(markerIcon!)
            : BitmapDescriptor.defaultMarker,
        position: LatLng(
          selectedLocation?.latitude ?? 0.0,
          selectedLocation?.longitude ?? 0.0,
        ),
      ),
    };
    emit(SetTransportationMarkersState());
  }

  Future<void> _loadMarkerIcon() async {
    markerIcon = await _getBytesFromAsset(ImageAssets.pin, 50);
    emit(SetTransportationMarkersState());
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> updateSelectedCameraPosition(
    LatLng latLng,
    BuildContext context,
  ) async {
    if (mapController != null && positionMapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
      await positionMapController!.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );

      _setSelectedLocation(latLng, context);
    }
  }

  void _setSelectedLocation(LatLng latLng, BuildContext? context) {
    selectedLocation = loc.LocationData.fromMap({
      "latitude": latLng.latitude,
      "longitude": latLng.longitude,
    });
    _getAddressFromLatLng(latLng.latitude, latLng.longitude);
    _setTransportationMarkers();
    emit(SetSelectedLocationState());
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    address = "Loading...";
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
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

  void _showLocationPermissionDialog(BuildContext context) {
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

  @override
  Future<void> close() {
    _positionStream?.cancel();
    return super.close();
  }
}
