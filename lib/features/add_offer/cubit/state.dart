abstract class AddOfferState {}

class AddOfferInitial extends AddOfferState {}

class SelectServiceState extends AddOfferState {}

class FilePickedSuccessfully extends AddOfferState {}

class FileNotPicked extends AddOfferState {}

class FileRemovedSuccessfully extends AddOfferState {}

class GetServiceTypesLoadingState extends AddOfferState {}

class GetSubServiceTypesLoadingState extends AddOfferState {}

class GetServiceTypesErrorState extends AddOfferState {}

class GetSubServiceTypesErrorState extends AddOfferState {}

class GetServiceTypesSuccessState extends AddOfferState {}

class GetSubServiceTypesSuccessState extends AddOfferState {}

class FailureAddOfferState extends AddOfferState {}

class SuccessAddOfferState extends AddOfferState {}

class LoadingAddOfferState extends AddOfferState {}
