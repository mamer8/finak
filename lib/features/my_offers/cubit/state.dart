abstract class MyOffersState {}

class MyOffersInitial extends MyOffersState {}

class SelectServiceState extends MyOffersState {}

class FilePickedSuccessfully extends MyOffersState {}

class FileNotPicked extends MyOffersState {}

class FileRemovedSuccessfully extends MyOffersState {}
class GetServicesLoadingState extends MyOffersState {}
class GetServicesErrorState extends MyOffersState {}
class GetServicesTypeErrorState extends MyOffersState {}
class GetServicesSuccessState extends MyOffersState {}
class ChangeSelectedServiceTypeState extends MyOffersState {}
class GetServicesTypeLoadingState extends MyOffersState {}
