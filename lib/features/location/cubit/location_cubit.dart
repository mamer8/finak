// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:finak/core/exports.dart';
import 'package:finak/features/location/data/repo.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;

import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this.api) : super(LocationInitial()) {
    _loadMarkerIcon();
  }

  LocationRepo api;
  StreamSubscription<Position>? _positionStream;
  Set<Marker> positionMarkers = <Marker>{};
  Uint8List? markerIcon;
  Uint8List? markerIconSelected;

  loc.LocationData? currentLocation;
  bool isFirstTime = true;
  loc.LocationData? selectedLocation;

  GoogleMapController? searchMapController;
  GoogleMapController? mapController;
  GoogleMapController? positionMapController;

  // String country = "country";
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
      _setServiceMarkesNull();
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

  _setServiceMarkesNull() {
    servicesMarkers = {
      Marker(
        markerId: const MarkerId('selectedLocation'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(
          selectedLocation?.latitude ?? 0.0,
          selectedLocation?.longitude ?? 0.0,
        ),
      ),
    };
    setCircle();
    selectedService = null;

    emit(SetTransportationMarkersState());
  }

  Future<void> _loadMarkerIcon() async {
    markerIcon = await _getBytesFromAsset(ImageAssets.pin, 30);
    markerIconSelected = await _getBytesFromAsset(ImageAssets.pin, 40);

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

  Future<void> updateSelectedPositionedCamera(
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

      setSelectedPositionedLocation(latLng, context);
    }
  }

  Future<void> updateSelectedCamera(
    LatLng latLng,
    BuildContext context,
  ) async {
    if (searchMapController != null) {
      await searchMapController!.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );

      _setSelectedLocation(latLng, context);
    }
  }

  void setSelectedPositionedLocation(LatLng latLng, BuildContext? context) {
    selectedLocation = loc.LocationData.fromMap({
      "latitude": latLng.latitude,
      "longitude": latLng.longitude,
    });
    _getAddressFromLatLng(latLng.latitude, latLng.longitude);
    _setTransportationMarkers();
    emit(SetSelectedLocationState());
  }
  void setSelectedPositionedLocationToDefault( ) {
    selectedLocation = loc.LocationData.fromMap({
      "latitude": currentLocation?.latitude ?? 0.0,
      "longitude": currentLocation?.longitude ?? 0.0,
    });
    _getAddressFromLatLng(selectedLocation!.latitude ?? 0.0, selectedLocation!.longitude ?? 0.0);
    _setTransportationMarkers();
    emit(SetSelectedLocationState());
  }

  void _setSelectedLocation(LatLng latLng, BuildContext? context) {
    selectedLocation = loc.LocationData.fromMap({
      "latitude": latLng.latitude,
      "longitude": latLng.longitude,
    });

    _setServiceMarkesNull();
    emit(SetSelectedLocationState());
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    // address = "Loading...";
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        // country = place.country ?? "";
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
    _getCountryInEnglish();
  }

  String? country;
  Future<void> _getCountryInEnglish() async {
    if (selectedLocation == null) {
      print("Current location is not available.");
      return;
    }
    country = await api.getCountryInEnglish(
      selectedLocation!.latitude ?? 0.0,
      selectedLocation!.longitude ?? 0.0,
    );
    emit(GetCurrentLocationAddressState());
    developer.log("Country: $country");
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

  TextEditingController searchController = TextEditingController();
  double currentValue = 2;
  double mapZoom = 12;
  // void setMapZoom() {

  //   double newZoom = (16 - (currentValue / 6)).clamp(5.0, 16.0);

  //   mapZoom = newZoom;

  //   if (searchMapController != null) {
  //     searchMapController!.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: LatLng(
  //             selectedLocation?.latitude ?? 0.0,
  //             selectedLocation?.longitude ?? 0.0,
  //           ),
  //           zoom: mapZoom,
  //         ),
  //       ),
  //     );
  //   }
  //   emit(SetMapZoomState());
  // }

  void setMapZoom() {
    final double radiusInMeters = currentValue * 1000;
    final LatLng center = LatLng(
      selectedLocation?.latitude ?? 0.0,
      selectedLocation?.longitude ?? 0.0,
    );

    final double lat = center.latitude;
    final double lng = center.longitude;

    // Earth radius in meters
    const double earthRadius = 6378137.0;

    // Angular distance in radians on a great circle
    double angularDistance = radiusInMeters / earthRadius;

    double latDelta = angularDistance * (180 / pi);
    double lngDelta = angularDistance * (180 / pi) / cos(lat * pi / 180);

    LatLng southWest = LatLng(lat - latDelta, lng - lngDelta);
    LatLng northEast = LatLng(lat + latDelta, lng + lngDelta);

    final bounds = LatLngBounds(southwest: southWest, northeast: northEast);

    if (searchMapController != null) {
      searchMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50), // 50 = padding in pixels
      );
    }

    emit(SetMapZoomState());
  }

  changeValue(double value) {
    currentValue = value;
    setCircle();
    emit(ChangeValueState());
  }

  ServiceModel? selectedService;
  Set<Marker> servicesMarkers = const <Marker>{};

  setMarkers(List<ServiceModel> services) {
    servicesMarkers = services
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id!.toString()),
            // infoWindow: const InfoWindow(title: 'currentLocation'),
            onTap: () {
              selectedService = e;

              emit(SetMarkersState());
              setMarkers(services);
            },
            icon: (markerIcon != null && markerIconSelected != null)
                ? selectedService?.id == e.id
                    ? BitmapDescriptor.bytes(markerIconSelected!)
                    : BitmapDescriptor.bytes(markerIcon!)
                : BitmapDescriptor.defaultMarker,
            position: LatLng(
              double.parse(e.lat ?? '0.0'),
              double.parse(e.long ?? '0.0'),
            ),
          ),
        )
        .toSet();
    emit(SetMarkersState());
  }

  GetServicesModel getServicesModel = GetServicesModel();
  void getServices(BuildContext context) async {
    selectedService = null;

    emit(GetServicesLoadingState());
    var response = await api.getServices(
      search: searchController.text,
      lat: selectedLocation?.latitude.toString() ?? '0.0',
      long: selectedLocation?.longitude.toString() ?? '0.0',
      distance: currentValue.toString(), ////asc,desc
    );
    response.fold(
      (failure) {
        emit(GetServicesErrorState());
      },
      (r) {
        getServicesModel = r;
        if (r.data != null) {
          if (r.data!.isNotEmpty) {
            selectedService = r.data!.first;
          }
        }
        setMarkers(getServicesModel.data ?? []);
        emit(GetServicesSuccessState());
      },
    );
  }

  updateFav(bool isFav, String id) {
    if (getServicesModel.data != null) {
      for (int i = 0; i < getServicesModel.data!.length; i++) {
        if (getServicesModel.data![i].id.toString() == id) {
          getServicesModel.data![i].isFav = isFav;
        }
      }
    }

    emit(GetServicesSuccessState());
  }

  Set<Circle> circles = const <Circle>{};
  setCircle() {
    circles = {
      Circle(
        circleId: const CircleId('1'),
        center: LatLng(selectedLocation?.latitude ?? 0.0,
            selectedLocation?.longitude ?? 0.0),
        radius: currentValue * 1000,

        strokeWidth: 2,
        strokeColor: AppColors.primary,
        // fillColor: Colors.black,
      ),
    };
    developer.log("circles: $circles");
    emit(SetCircleState());
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    return super.close();
  }
}
