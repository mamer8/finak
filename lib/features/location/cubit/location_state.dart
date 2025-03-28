abstract class LocationState {}

class LocationInitial extends LocationState {}
class GetCurrentLocationState extends LocationState {}
class DisposeMapState extends LocationState {}
class GetCurrentLocationAddressState extends LocationState {}
class ErrorCurrentLocationAddressState extends LocationState {}
class SetTransportationMarkersState extends LocationState {}
class SetSelectedLocationState extends LocationState {}
class ChangeValueState extends LocationState {}
